#==============================================================================
# ■ FO_EntityVisualSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 2.6.1
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema visual de entidades do mapa.
#------------------------------------------------------------------------------
# Funções atuais:
# - Nome das entidades
# - Cores por tipo
# - Barra de HP apenas para Mob e Boss
# - Nome ajustado para NPC e Quest
# - Ícone de fúria para Mob/Boss
# - Tom avermelhado quando em fúria
# - Ocultar visual ao morrer
# - Reaparecer no respawn
#==============================================================================

module FO_EntityVisualConfig

  FONT_NAME = "Arial"

  FONT_SIZE = 18

  FONT_BOLD = true

  NAME_OFFSET_X = -100

  NAME_OFFSET_Y = -48

  NPC_NAME_EXTRA_OFFSET_Y = 18

  HP_BARFUNDO_OFFSET_X = -32

  HP_BARFUNDO_OFFSET_Y = -12

  HP_BAR_OFFSET_X = -31

  HP_BAR_OFFSET_Y = -11

  FURY_ICON_PICTURE_NAME = "StatusFuria"

  FURY_ICON_OFFSET_X = 0

  FURY_ICON_OFFSET_Y = -78

  FURY_ICON_OPACITY = 255

  ENABLE_FURY_TONE = true

  FURY_TONE_RED = 255

  FURY_TONE_GREEN = 0

  FURY_TONE_BLUE = 0

  FURY_TONE_GRAY = 0

end

class FO_EntityVisual

  def initialize(entity_data, viewport)

    @entity_data = entity_data

    @event = entity_data[:event]

    @entity_type = entity_data[:type]

    @viewport = viewport

    @runtime = FO_EntityRuntimeManager.find_by_event(
      @event
    )

    setup_name

    create_name_sprite

    create_hp_bar if uses_hp_bar?

    create_fury_icon if uses_fury_icon?

    FO_Logger.action(
      "Visual criado para #{@display_name}"
    )

  end

  def setup_name

    original_name = @event.event.name

    @display_name = original_name[1..original_name.size]

  end

  def uses_hp_bar?

    return true if @entity_type == :mob

    return true if @entity_type == :boss

    return false

  end

  def uses_fury_icon?

    return true if @entity_type == :mob

    return true if @entity_type == :boss

    return false

  end

  def create_name_sprite

    @name_sprite = Sprite.new(@viewport)

    @name_sprite.bitmap = Bitmap.new(200, 40)

    @name_sprite.bitmap.font.name =
      FO_EntityVisualConfig::FONT_NAME

    @name_sprite.bitmap.font.size =
      FO_EntityVisualConfig::FONT_SIZE

    @name_sprite.bitmap.font.bold =
      FO_EntityVisualConfig::FONT_BOLD

    text_color = get_text_color

    draw_text_outline(
      @name_sprite.bitmap,
      @display_name,
      text_color
    )

    @name_sprite.z = 99999

  end

  def draw_text_outline(bitmap, text, color)

    bitmap.font.color = Color.new(0, 0, 0)

    offsets = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1]
    ]

    for offset in offsets

      bitmap.draw_text(
        offset[0],
        offset[1],
        200,
        40,
        text,
        1
      )

    end

    bitmap.font.color = color

    bitmap.draw_text(
      0,
      0,
      200,
      40,
      text,
      1
    )

  end

  def get_text_color

    case @entity_type

    when :boss

      return Color.new(255, 80, 80)

    when :quest

      return Color.new(255, 255, 0)

    else

      return Color.new(255, 255, 255)

    end

  end

  def create_hp_bar

    @hp_background = Sprite.new(@viewport)

    @hp_background.bitmap = RPG::Cache.picture(
      "HPMobFundo"
    )

    @hp_background.z = 99998

    @hp_bar = Sprite.new(@viewport)

    @hp_bar.bitmap = RPG::Cache.picture(
      "HPMobInterno"
    )

    @hp_bar.z = 99999

  end

  def create_fury_icon

    @fury_icon = Sprite.new(@viewport)

    @fury_icon.bitmap = RPG::Cache.picture(
      FO_EntityVisualConfig::FURY_ICON_PICTURE_NAME
    )

    @fury_icon.visible = false

    @fury_icon.opacity =
      FO_EntityVisualConfig::FURY_ICON_OPACITY

    @fury_icon.z = 100000

  end

  def update

    return if @event.nil?

    refresh_runtime

    update_visibility

    update_fury_tone

    return unless visual_visible?

    update_name_position

    update_hp_position if uses_hp_bar?

    update_hp_bar if uses_hp_bar?

    update_fury_icon if uses_fury_icon?

  end

  def refresh_runtime

    return unless @runtime.nil?

    @runtime = FO_EntityRuntimeManager.find_by_event(
      @event
    )

  end

  def visual_visible?

    return true if @runtime.nil?

    return @runtime.alive?

  end

  def fury_active?

    return false if @runtime.nil?

    return @runtime.instance_variable_get(:@fo_fury) == true

  end

  def update_visibility

    visible = visual_visible?

    @name_sprite.visible = visible if @name_sprite

    if uses_hp_bar?

      @hp_background.visible = visible if @hp_background

      @hp_bar.visible = visible if @hp_bar

    end

    if uses_fury_icon?

      if @fury_icon

        @fury_icon.visible = visible && fury_active?

      end

    end

  end

  def update_fury_tone

    return unless uses_fury_icon?

    return unless FO_EntityVisualConfig::ENABLE_FURY_TONE

    return if @event.nil?

    if visual_visible? && fury_active?

      @event.instance_variable_set(
        :@tone,
        Tone.new(
          FO_EntityVisualConfig::FURY_TONE_RED,
          FO_EntityVisualConfig::FURY_TONE_GREEN,
          FO_EntityVisualConfig::FURY_TONE_BLUE,
          FO_EntityVisualConfig::FURY_TONE_GRAY
        )
      )

    else

      @event.instance_variable_set(
        :@tone,
        Tone.new(0, 0, 0, 0)
      )

    end

  end

  def get_sprite_height

    character_name = @event.character_name

    bitmap = RPG::Cache.character(
      character_name,
      0
    )

    return bitmap.height / 4

  end

  def update_name_position

    sprite_height = get_sprite_height

    extra_offset_y = 0

    unless uses_hp_bar?

      extra_offset_y =
        FO_EntityVisualConfig::NPC_NAME_EXTRA_OFFSET_Y

    end

    @name_sprite.x =
      @event.screen_x +
      FO_EntityVisualConfig::NAME_OFFSET_X

    @name_sprite.y =
      @event.screen_y -
      sprite_height +
      FO_EntityVisualConfig::NAME_OFFSET_Y +
      extra_offset_y

  end

  def update_hp_position

    return unless uses_hp_bar?

    sprite_height = get_sprite_height

    @hp_background.x =
      @event.screen_x +
      FO_EntityVisualConfig::HP_BARFUNDO_OFFSET_X

    @hp_background.y =
      @event.screen_y -
      sprite_height +
      FO_EntityVisualConfig::HP_BARFUNDO_OFFSET_Y

    @hp_bar.x =
      @event.screen_x +
      FO_EntityVisualConfig::HP_BAR_OFFSET_X

    @hp_bar.y =
      @event.screen_y -
      sprite_height +
      FO_EntityVisualConfig::HP_BAR_OFFSET_Y

  end

  def update_hp_bar

    return unless uses_hp_bar?

    return if @runtime.nil?

    hp_rate = @runtime.hp_rate

    width = (@hp_bar.bitmap.width * hp_rate).to_i

    @hp_bar.src_rect.set(
      0,
      0,
      width,
      @hp_bar.bitmap.height
    )

  end

  def update_fury_icon

    return unless uses_fury_icon?

    return if @fury_icon.nil?

    @fury_icon.visible =
      visual_visible? && fury_active?

    return unless @fury_icon.visible

    sprite_height = get_sprite_height

    @fury_icon.x =
      @event.screen_x -
      (@fury_icon.bitmap.width / 2) +
      FO_EntityVisualConfig::FURY_ICON_OFFSET_X

    @fury_icon.y =
      @event.screen_y -
      sprite_height +
      FO_EntityVisualConfig::FURY_ICON_OFFSET_Y

  end

  def dispose

    @event.instance_variable_set(
      :@tone,
      Tone.new(0, 0, 0, 0)
    ) if @event

    @name_sprite.dispose if @name_sprite

    @hp_background.dispose if @hp_background

    @hp_bar.dispose if @hp_bar

    @fury_icon.dispose if @fury_icon

  end

end

module FO_EntityVisualManager

  @visuals = []

  @viewport = nil

  @initialized = false

  @map_id = nil

  def self.setup

    return if $game_map.nil?

    return if FO_MapEntitySystem.map_entities.empty?

    dispose

    @viewport = Viewport.new(0, 0, 640, 480)

    @viewport.z = 99999

    for entity_data in FO_MapEntitySystem.map_entities

      event = entity_data[:event]

      next if event.nil?

      visual = FO_EntityVisual.new(
        entity_data,
        @viewport
      )

      @visuals.push(visual)

    end

    @initialized = true

    @map_id = $game_map.map_id

    FO_Logger.action(
      "Visuais inicializados."
    )

  end

  def self.update

    return if $game_map.nil?

    if @map_id != $game_map.map_id

      @initialized = false

    end

    unless @initialized

      setup

    end

    for visual in @visuals

      visual.update

    end

  end

  def self.dispose

    for visual in @visuals

      visual.dispose

    end

    @visuals.clear

    if @viewport

      @viewport.dispose

      @viewport = nil

    end

    @initialized = false

  end

end

class Scene_Map

  alias fo_entity_visual_update update

  def update

    FO_EntityVisualManager.update

    fo_entity_visual_update

  end

end

FO_Logger.action(
  "FO_EntityVisualSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "map",
  "FO_EntityVisualSystem carregado."
)

FO_CORE.debug(
  "FO_EntityVisualSystem carregado com sucesso."
)