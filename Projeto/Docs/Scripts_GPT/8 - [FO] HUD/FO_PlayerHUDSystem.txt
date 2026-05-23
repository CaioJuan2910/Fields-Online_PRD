#==============================================================================
# ■ FO_PlayerHUDSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.1.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# HUD principal do player.
#------------------------------------------------------------------------------
# Funções atuais:
# - Barra de HP do player
# - Texto HP centralizado
# - Texto dentro da barra
# - Nome do player
# - Atualização em tempo real
#==============================================================================

module FO_PlayerHUDConfig

  HUD_ENABLED = true

  HUD_X = 16

  HUD_Y = 16

  PLAYER_NAME = "Player"

  FONT_NAME = "Arial"

  FONT_SIZE = 16

  FONT_BOLD = true

  HP_BACKGROUND_IMAGE = "HPPlayerFundo"

  HP_BAR_IMAGE = "HPPlayerInterno"

  HP_BAR_X = 0

  HP_BAR_Y = 24

  HP_TEXT_X = 0

  HP_TEXT_Y = 22

  NAME_TEXT_X = 0

  NAME_TEXT_Y = 0

  HUD_Z = 200000

  HP_TEXT_COLOR = Color.new(255, 255, 255)

end

class FO_PlayerHUD

  def initialize

    @viewport = Viewport.new(0, 0, 640, 480)

    @viewport.z = FO_PlayerHUDConfig::HUD_Z

    create_name_sprite

    create_hp_background

    create_hp_bar

    create_hp_text

    refresh

  end

  def create_name_sprite

    @name_sprite = Sprite.new(@viewport)

    @name_sprite.bitmap = Bitmap.new(220, 24)

    @name_sprite.x =
      FO_PlayerHUDConfig::HUD_X +
      FO_PlayerHUDConfig::NAME_TEXT_X

    @name_sprite.y =
      FO_PlayerHUDConfig::HUD_Y +
      FO_PlayerHUDConfig::NAME_TEXT_Y

    setup_font(@name_sprite.bitmap)

  end

  def create_hp_background

    @hp_background = Sprite.new(@viewport)

    @hp_background.bitmap = RPG::Cache.picture(
      FO_PlayerHUDConfig::HP_BACKGROUND_IMAGE
    )

    @hp_background.x =
      FO_PlayerHUDConfig::HUD_X +
      FO_PlayerHUDConfig::HP_BAR_X

    @hp_background.y =
      FO_PlayerHUDConfig::HUD_Y +
      FO_PlayerHUDConfig::HP_BAR_Y

  end

  def create_hp_bar

    @hp_bar = Sprite.new(@viewport)

    @hp_bar.bitmap = RPG::Cache.picture(
      FO_PlayerHUDConfig::HP_BAR_IMAGE
    )

    @hp_bar.x =
      FO_PlayerHUDConfig::HUD_X +
      FO_PlayerHUDConfig::HP_BAR_X

    @hp_bar.y =
      FO_PlayerHUDConfig::HUD_Y +
      FO_PlayerHUDConfig::HP_BAR_Y

  end

  def create_hp_text

    @hp_text = Sprite.new(@viewport)

    @hp_text.bitmap = Bitmap.new(220, 24)

    @hp_text.x =
      FO_PlayerHUDConfig::HUD_X +
      FO_PlayerHUDConfig::HP_TEXT_X

    @hp_text.y =
      FO_PlayerHUDConfig::HUD_Y +
      FO_PlayerHUDConfig::HP_TEXT_Y

    setup_font(@hp_text.bitmap)

  end

  def setup_font(bitmap)

    bitmap.font.name = FO_PlayerHUDConfig::FONT_NAME

    bitmap.font.size = FO_PlayerHUDConfig::FONT_SIZE

    bitmap.font.bold = FO_PlayerHUDConfig::FONT_BOLD

  end

  def update

    return unless FO_PlayerHUDConfig::HUD_ENABLED

    refresh

  end

  def refresh

    update_visibility

    return unless visible?

    refresh_name

    refresh_hp_bar

    refresh_hp_text

  end

  def update_visibility

    visible = visible?

    @name_sprite.visible = visible if @name_sprite

    @hp_background.visible = visible if @hp_background

    @hp_bar.visible = visible if @hp_bar

    @hp_text.visible = visible if @hp_text

  end

  def visible?

    return false unless FO_PlayerHUDConfig::HUD_ENABLED

    return false unless defined?(FO_PlayerRuntime)

    return true

  end

  def refresh_name

    @name_sprite.bitmap.clear

    draw_text_outline(
      @name_sprite.bitmap,
      FO_PlayerHUDConfig::PLAYER_NAME,
      Color.new(255, 255, 255),
      0
    )

  end

  def refresh_hp_bar

    rate = FO_PlayerRuntime.hp_rate

    rate = 0.0 if rate < 0.0

    rate = 1.0 if rate > 1.0

    width = (@hp_bar.bitmap.width * rate).to_i

    @hp_bar.src_rect.set(
      0,
      0,
      width,
      @hp_bar.bitmap.height
    )

  end

  def refresh_hp_text

    @hp_text.bitmap.clear

    text =
      "#{FO_PlayerRuntime.hp}/#{FO_PlayerRuntime.max_hp}"

    draw_text_outline(
      @hp_text.bitmap,
      text,
      FO_PlayerHUDConfig::HP_TEXT_COLOR,
      1
    )

  end

  def draw_text_outline(bitmap, text, color, align = 0)

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
        bitmap.width,
        bitmap.height,
        text,
        align
      )

    end

    bitmap.font.color = color

    bitmap.draw_text(
      0,
      0,
      bitmap.width,
      bitmap.height,
      text,
      align
    )

  end

  def dispose

    @name_sprite.bitmap.dispose if @name_sprite && @name_sprite.bitmap

    @name_sprite.dispose if @name_sprite

    @hp_background.dispose if @hp_background

    @hp_bar.dispose if @hp_bar

    @hp_text.bitmap.dispose if @hp_text && @hp_text.bitmap

    @hp_text.dispose if @hp_text

    @viewport.dispose if @viewport

  end

end

module FO_PlayerHUDManager

  @hud = nil

  def self.setup

    dispose

    @hud = FO_PlayerHUD.new

    FO_Logger.action(
      "Player HUD inicializada."
    )

  end

  def self.update

    setup if @hud.nil?

    @hud.update if @hud

  end

  def self.dispose

    if @hud

      @hud.dispose

      @hud = nil

    end

  end

end

class Scene_Map

  alias fo_player_hud_main main

  def main

    FO_PlayerHUDManager.setup

    fo_player_hud_main

    FO_PlayerHUDManager.dispose

  end

  alias fo_player_hud_update update

  def update

    FO_PlayerHUDManager.update

    fo_player_hud_update

  end

end

FO_Logger.action(
  "FO_PlayerHUDSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "hud",
  "FO_PlayerHUDSystem carregado."
)

FO_CORE.debug(
  "FO_PlayerHUDSystem carregado com sucesso."
)