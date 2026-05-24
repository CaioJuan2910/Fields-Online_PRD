#==============================================================================
# ■ FO_FloatingLootSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema visual de loot flutuante.
#------------------------------------------------------------------------------
# Funções atuais:
# - Texto flutuante ao receber loot
# - Movimento para cima
# - Fade out
# - Múltiplos loots simultâneos
#==============================================================================

module FO_FloatingLootConfig

  FONT_NAME = "Arial"

  FONT_SIZE = 16

  FONT_BOLD = true

  TEXT_COLOR = Color.new(255, 230, 80)

  OUTLINE_COLOR = Color.new(0, 0, 0)

  FLOAT_DURATION = 90

  FLOAT_SPEED_Y = 1

  START_OFFSET_X = -80

  START_OFFSET_Y = -48

  LINE_SPACING = 18

  VIEWPORT_Z = 200001

end

class FO_FloatingLoot

  def initialize(event, item_name, index = 0, viewport = nil)

    @event = event

    @item_name = item_name

    @index = index

    @viewport = viewport

    @duration = FO_FloatingLootConfig::FLOAT_DURATION

    create_sprite

    update_position

  end

  def create_sprite

    @sprite = Sprite.new(@viewport)

    @sprite.bitmap = Bitmap.new(160, 32)

    @sprite.bitmap.font.name =
      FO_FloatingLootConfig::FONT_NAME

    @sprite.bitmap.font.size =
      FO_FloatingLootConfig::FONT_SIZE

    @sprite.bitmap.font.bold =
      FO_FloatingLootConfig::FONT_BOLD

    draw_text

    @sprite.z = FO_FloatingLootConfig::VIEWPORT_Z

  end

  def draw_text

    text = "+ #{@item_name}"

    bitmap = @sprite.bitmap

    bitmap.clear

    bitmap.font.color =
      FO_FloatingLootConfig::OUTLINE_COLOR

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
        bitmap.width,
        bitmap.height,
        text,
        1
      )

    end

    bitmap.font.color =
      FO_FloatingLootConfig::TEXT_COLOR

    bitmap.draw_text(
      0,
      0,
      bitmap.width,
      bitmap.height,
      text,
      1
    )

  end

  def update

    return if disposed?

    @duration -= 1

    update_position

    update_animation

    dispose if @duration <= 0

  end

  def update_position

    return if @event.nil?
    return if @sprite.nil?

    index_offset =
      @index * FO_FloatingLootConfig::LINE_SPACING

    elapsed =
      FO_FloatingLootConfig::FLOAT_DURATION - @duration

    @sprite.x =
      @event.screen_x +
      FO_FloatingLootConfig::START_OFFSET_X

    @sprite.y =
      @event.screen_y +
      FO_FloatingLootConfig::START_OFFSET_Y -
      index_offset -
      (elapsed * FO_FloatingLootConfig::FLOAT_SPEED_Y)

  end

  def update_animation

    return if @sprite.nil?

    rate =
      @duration.to_f /
      FO_FloatingLootConfig::FLOAT_DURATION.to_f

    @sprite.opacity = (255 * rate).to_i

  end

  def disposed?

    return true if @sprite.nil?

    return @sprite.disposed?

  end

  def dispose

    return if @sprite.nil?

    if @sprite.bitmap

      @sprite.bitmap.dispose

    end

    @sprite.dispose

    @sprite = nil

  end

end

module FO_FloatingLootManager

  @loots = []

  @viewport = nil

  def self.setup

    return unless @viewport.nil?

    @viewport = Viewport.new(0, 0, 640, 480)

    @viewport.z = FO_FloatingLootConfig::VIEWPORT_Z

  end

  def self.show(event, item_name, index = 0)

    setup

    loot = FO_FloatingLoot.new(
      event,
      item_name,
      index,
      @viewport
    )

    @loots.push(loot)

  end

  def self.show_multiple(event, items)

    return if items.nil?

    index = 0

    for item_name in items

      show(
        event,
        item_name,
        index
      )

      index += 1

    end

  end

  def self.update

    setup

    for loot in @loots.clone

      loot.update

      if loot.disposed?

        @loots.delete(loot)

      end

    end

  end

  def self.dispose

    for loot in @loots

      loot.dispose

    end

    @loots.clear

    if @viewport

      @viewport.dispose

      @viewport = nil

    end

  end

end

class Scene_Map

  alias fo_floating_loot_update update

  def update

    FO_FloatingLootManager.update

    fo_floating_loot_update

  end

  alias fo_floating_loot_main main

  def main

    fo_floating_loot_main

    FO_FloatingLootManager.dispose

  end

end

FO_Logger.action(
  "FO_FloatingLootSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "hud",
  "FO_FloatingLootSystem carregado."
)

FO_CORE.debug(
  "FO_FloatingLootSystem carregado com sucesso."
)