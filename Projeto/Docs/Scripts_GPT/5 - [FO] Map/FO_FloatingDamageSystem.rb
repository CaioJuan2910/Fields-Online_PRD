#==============================================================================
# ■ FO_FloatingDamageSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 20/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de dano flutuante estilo MMORPG/Ragnarok.
#==============================================================================

module FO_FloatingDamageConfig

  FONT_NAME = "Arial"
  FONT_SIZE = 22
  FONT_BOLD = true

  FLOAT_DURATION = 45
  FLOAT_SPEED_Y  = -1
  FLOAT_OFFSET_X = -40
  FLOAT_OFFSET_Y = -70

end

class FO_FloatingDamage

  def initialize(event, value, viewport)

    @event = event
    @value = value.to_s
    @viewport = viewport

    @duration = FO_FloatingDamageConfig::FLOAT_DURATION

    @sprite = Sprite.new(@viewport)
    @sprite.bitmap = Bitmap.new(80, 32)

    @sprite.bitmap.font.name = FO_FloatingDamageConfig::FONT_NAME
    @sprite.bitmap.font.size = FO_FloatingDamageConfig::FONT_SIZE
    @sprite.bitmap.font.bold = FO_FloatingDamageConfig::FONT_BOLD

    draw_text

    @sprite.x = @event.screen_x + FO_FloatingDamageConfig::FLOAT_OFFSET_X
    @sprite.y = @event.screen_y + FO_FloatingDamageConfig::FLOAT_OFFSET_Y
    @sprite.z = 999999

  end

  def draw_text

    @sprite.bitmap.font.color = Color.new(0, 0, 0)

    @sprite.bitmap.draw_text(-1, 0, 80, 32, @value, 1)
    @sprite.bitmap.draw_text(1, 0, 80, 32, @value, 1)
    @sprite.bitmap.draw_text(0, -1, 80, 32, @value, 1)
    @sprite.bitmap.draw_text(0, 1, 80, 32, @value, 1)

    @sprite.bitmap.font.color = Color.new(255, 255, 255)

    @sprite.bitmap.draw_text(0, 0, 80, 32, @value, 1)

  end

  def update

    @duration -= 1

    @sprite.y += FO_FloatingDamageConfig::FLOAT_SPEED_Y

    @sprite.opacity = (@duration * 255) / FO_FloatingDamageConfig::FLOAT_DURATION

  end

  def finished?

    return @duration <= 0

  end

  def dispose

    @sprite.bitmap.dispose if @sprite.bitmap
    @sprite.dispose if @sprite

  end

end

module FO_FloatingDamageManager

  @damages = []
  @viewport = nil

  def self.setup

    return if @viewport

    @viewport = Viewport.new(0, 0, 640, 480)
    @viewport.z = 999999

  end

  def self.show(event, value)

    setup

    damage = FO_FloatingDamage.new(event, value, @viewport)

    @damages.push(damage)

  end

  def self.update

    setup

    for damage in @damages

      damage.update

    end

    @damages.delete_if do |damage|

      if damage.finished?
        damage.dispose
        true
      else
        false
      end

    end

  end

  def self.dispose

    for damage in @damages

      damage.dispose

    end

    @damages.clear

    if @viewport
      @viewport.dispose
      @viewport = nil
    end

  end

end

class Scene_Map

  alias fo_floating_damage_update update

  def update

    FO_FloatingDamageManager.update

    fo_floating_damage_update

  end

end

FO_Logger.action(
  "FO_FloatingDamageSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "map",
  "FO_FloatingDamageSystem carregado."
)

FO_CORE.debug(
  "FO_FloatingDamageSystem carregado com sucesso."
)