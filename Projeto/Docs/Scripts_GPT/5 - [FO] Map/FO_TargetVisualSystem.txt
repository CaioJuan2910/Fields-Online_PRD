#==============================================================================
# ■ FO_TargetVisualSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.2.1
# Data......: 20/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema visual de target MMORPG.
#==============================================================================

module FO_TargetVisualConfig

  #===========================================================================
  # ■ CONFIGURAÇÕES
  #===========================================================================

  TARGET_PICTURE_NAME = "TargetCircle"

  TARGET_OFFSET_Y = -10

  TARGET_OPACITY = 220

  TARGET_Z_OFFSET = -1

end

#==============================================================================
# ■ FO_TargetVisual
#==============================================================================

module FO_TargetVisual

  @sprite = nil

  @viewport = nil

  #===========================================================================
  # ■ set_viewport
  #===========================================================================
  def self.set_viewport(viewport)

    @viewport = viewport

    recreate_sprite

  end

  #===========================================================================
  # ■ recreate_sprite
  #===========================================================================
  def self.recreate_sprite

    dispose_sprite

    return if @viewport.nil?

    @sprite = Sprite.new(@viewport)

    @sprite.bitmap = RPG::Cache.picture(
      FO_TargetVisualConfig::TARGET_PICTURE_NAME
    )

    @sprite.visible = false

    @sprite.opacity =
      FO_TargetVisualConfig::TARGET_OPACITY

  end

  #===========================================================================
  # ■ update
  #===========================================================================
  def self.update

    return if @sprite.nil?

    target = FO_TargetSystem.current_target

    if target.nil?

      hide

      return

    end

    runtime = FO_EntityRuntimeManager.find_by_event(
      target
    )

    if runtime.nil? || runtime.dead?

      hide

      return

    end

    show

    update_position(target)

    update_z(target)

  end

  #===========================================================================
  # ■ update_position
  #===========================================================================
  def self.update_position(target)

    @sprite.x =
      target.screen_x -
      (@sprite.bitmap.width / 2)

    @sprite.y =
      target.screen_y -
      (@sprite.bitmap.height / 2) +
      FO_TargetVisualConfig::TARGET_OFFSET_Y

  end

  #===========================================================================
  # ■ update_z
  #===========================================================================
  def self.update_z(target)

    @sprite.z =
      target.screen_z(0) +
      FO_TargetVisualConfig::TARGET_Z_OFFSET

  end

  #===========================================================================
  # ■ show
  #===========================================================================
  def self.show

    @sprite.visible = true if @sprite

  end

  #===========================================================================
  # ■ hide
  #===========================================================================
  def self.hide

    @sprite.visible = false if @sprite

  end

  #===========================================================================
  # ■ dispose_sprite
  #===========================================================================
  def self.dispose_sprite

    if @sprite

      @sprite.dispose

      @sprite = nil

    end

  end

  #===========================================================================
  # ■ dispose
  #===========================================================================
  def self.dispose

    dispose_sprite

    @viewport = nil

  end

end

#==============================================================================
# ■ Spriteset_Map
#------------------------------------------------------------------------------
# Usa a mesma viewport dos characters do mapa.
#==============================================================================

class Spriteset_Map

  alias fo_target_visual_initialize initialize

  #===========================================================================
  # ■ initialize
  #===========================================================================
  def initialize

    fo_target_visual_initialize

    FO_TargetVisual.set_viewport(
      @viewport1
    )

  end

  alias fo_target_visual_dispose dispose

  #===========================================================================
  # ■ dispose
  #===========================================================================
  def dispose

    FO_TargetVisual.dispose

    fo_target_visual_dispose

  end

end

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map

  alias fo_target_visual_update update

  #===========================================================================
  # ■ update
  #===========================================================================
  def update

    FO_TargetVisual.update

    fo_target_visual_update

  end

end

#==============================================================================
# ■ Inicialização
#==============================================================================

FO_Logger.action(
  "FO_TargetVisualSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "map",
  "FO_TargetVisualSystem carregado."
)

FO_CORE.debug(
  "FO_TargetVisualSystem carregado com sucesso."
)