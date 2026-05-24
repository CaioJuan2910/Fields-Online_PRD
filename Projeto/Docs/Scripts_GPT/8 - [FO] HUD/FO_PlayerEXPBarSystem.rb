#==============================================================================
# ■ FO_PlayerEXPBarSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# HUD de experiência e level do player.
#------------------------------------------------------------------------------
# Funções atuais:
# - Barra de EXP
# - Texto de Level
# - Atualização em tempo real
# - Integração com FO_PlayerLevelSystem
#==============================================================================

module FO_PlayerEXPBarConfig

  ENABLED = true

  HUD_X = 16

  HUD_Y = 78

  BAR_BACKGROUND_IMAGE = "EXPPlayerFundo"

  BAR_IMAGE = "EXPPlayerInterno"

  BAR_OFFSET_X = 0

  BAR_OFFSET_Y = 0

  LEVEL_TEXT_X = 0

  LEVEL_TEXT_Y = -20

  EXP_TEXT_X = 0

  EXP_TEXT_Y = 0

  FONT_NAME = "Arial"

  FONT_SIZE = 14

  FONT_BOLD = true

  TEXT_COLOR = Color.new(255, 255, 255)

  HUD_Z = 200000

end

class FO_PlayerEXPBar

  def initialize

    @viewport = Viewport.new(0, 0, 640, 480)

    @viewport.z = FO_PlayerEXPBarConfig::HUD_Z

    create_background

    create_bar

    create_level_text

    create_exp_text

    refresh

  end

  def create_background

    @background = Sprite.new(@viewport)

    @background.bitmap = RPG::Cache.picture(
      FO_PlayerEXPBarConfig::BAR_BACKGROUND_IMAGE
    )

    @background.x =
      FO_PlayerEXPBarConfig::HUD_X +
      FO_PlayerEXPBarConfig::BAR_OFFSET_X

    @background.y =
      FO_PlayerEXPBarConfig::HUD_Y +
      FO_PlayerEXPBarConfig::BAR_OFFSET_Y

  end

  def create_bar

    @bar = Sprite.new(@viewport)

    @bar.bitmap = RPG::Cache.picture(
      FO_PlayerEXPBarConfig::BAR_IMAGE
    )

    @bar.x =
      FO_PlayerEXPBarConfig::HUD_X +
      FO_PlayerEXPBarConfig::BAR_OFFSET_X

    @bar.y =
      FO_PlayerEXPBarConfig::HUD_Y +
      FO_PlayerEXPBarConfig::BAR_OFFSET_Y

  end

  def create_level_text

    @level_text = Sprite.new(@viewport)

    @level_text.bitmap = Bitmap.new(220, 24)

    @level_text.x =
      FO_PlayerEXPBarConfig::HUD_X +
      FO_PlayerEXPBarConfig::LEVEL_TEXT_X

    @level_text.y =
      FO_PlayerEXPBarConfig::HUD_Y +
      FO_PlayerEXPBarConfig::LEVEL_TEXT_Y

    setup_font(@level_text.bitmap)

  end

  def create_exp_text

    @exp_text = Sprite.new(@viewport)

    @exp_text.bitmap = Bitmap.new(220, 24)

    @exp_text.x =
      FO_PlayerEXPBarConfig::HUD_X +
      FO_PlayerEXPBarConfig::EXP_TEXT_X

    @exp_text.y =
      FO_PlayerEXPBarConfig::HUD_Y +
      FO_PlayerEXPBarConfig::EXP_TEXT_Y

    setup_font(@exp_text.bitmap)

  end

  def setup_font(bitmap)

    bitmap.font.name =
      FO_PlayerEXPBarConfig::FONT_NAME

    bitmap.font.size =
      FO_PlayerEXPBarConfig::FONT_SIZE

    bitmap.font.bold =
      FO_PlayerEXPBarConfig::FONT_BOLD

  end

  def update

    return unless visible?

    refresh

  end

  def refresh

    refresh_exp_bar

    refresh_level_text

    refresh_exp_text

  end

  def visible?

    return false unless FO_PlayerEXPBarConfig::ENABLED

    return false unless defined?(FO_PlayerLevelSystem)

    return true

  end

  def refresh_exp_bar

    rate = FO_PlayerLevelSystem.exp_rate

    rate = 0.0 if rate < 0.0

    rate = 1.0 if rate > 1.0

    width = (@bar.bitmap.width * rate).to_i

    @bar.src_rect.set(
      0,
      0,
      width,
      @bar.bitmap.height
    )

  end

  def refresh_level_text

    @level_text.bitmap.clear

    text =
      "Lv #{FO_PlayerLevelSystem.level}"

    draw_text_outline(
      @level_text.bitmap,
      text,
      FO_PlayerEXPBarConfig::TEXT_COLOR,
      0
    )

  end

  def refresh_exp_text

    @exp_text.bitmap.clear

    text =
      "#{FO_PlayerLevelSystem.exp}/#{FO_PlayerLevelSystem.next_level_exp}"

    draw_text_outline(
      @exp_text.bitmap,
      text,
      FO_PlayerEXPBarConfig::TEXT_COLOR,
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

    @background.dispose if @background

    @bar.dispose if @bar

    if @level_text

      @level_text.bitmap.dispose

      @level_text.dispose

    end

    if @exp_text

      @exp_text.bitmap.dispose

      @exp_text.dispose

    end

    @viewport.dispose if @viewport

  end

end

module FO_PlayerEXPBarManager

  @hud = nil

  def self.setup

    dispose

    @hud = FO_PlayerEXPBar.new

    FO_Logger.action(
      "EXP HUD inicializada."
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

  alias fo_player_exp_bar_main main

  def main

    FO_PlayerEXPBarManager.setup

    fo_player_exp_bar_main

    FO_PlayerEXPBarManager.dispose

  end

  alias fo_player_exp_bar_update update

  def update

    FO_PlayerEXPBarManager.update

    fo_player_exp_bar_update

  end

end

FO_Logger.action(
  "FO_PlayerEXPBarSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "hud",
  "FO_PlayerEXPBarSystem carregado."
)

FO_CORE.debug(
  "FO_PlayerEXPBarSystem carregado com sucesso."
)