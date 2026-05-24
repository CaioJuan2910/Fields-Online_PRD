#==============================================================================
# ■ FO_AutoAttackSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.3.0
# Data......: 20/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de auto attack do jogador.
#------------------------------------------------------------------------------
# Funções atuais:
# - Auto attack
# - Face target
# - Animação do player
# - Animação de hit no alvo
# - Dano runtime
#==============================================================================

module FO_AutoAttackConfig

  ATTACK_RANGE = 1

  ATTACK_SPEED = 60

  BASE_DAMAGE = 25

  ENABLE_FACE_TARGET = true

  ENABLE_PLAYER_ATTACK_ANIMATION = true

  ENABLE_TARGET_HIT_ANIMATION = true

  PLAYER_ATTACK_ANIMATION_ID = 1

  TARGET_HIT_ANIMATION_ID = 2

end

module FO_AutoAttackSystem

  @attack_timer = 0

  def self.update

    update_attack_timer

    process_auto_attack

  end

  def self.update_attack_timer

    if @attack_timer > 0

      @attack_timer -= 1

    end

  end

  def self.process_auto_attack

    return if @attack_timer > 0

    target = FO_TargetSystem.current_target

    return if target.nil?

    unless FO_TargetSystem.valid_target?(target)

      FO_TargetSystem.clear_target

      return

    end

    runtime = FO_EntityRuntimeManager.find_by_event(
      target
    )

    return if runtime.nil?

    return unless in_attack_range?(target)

    execute_attack(target, runtime)

  end

  def self.in_attack_range?(target)

    dx = ($game_player.x - target.x).abs

    dy = ($game_player.y - target.y).abs

    distance = dx + dy

    return distance <= FO_AutoAttackConfig::ATTACK_RANGE

  end

  def self.execute_attack(target, runtime)

    face_target(target)

    play_player_attack_animation

    play_target_hit_animation(target)

    damage = calculate_damage

    runtime.damage(damage)

    start_attack_cooldown

    FO_Logger.action(
      "Player atacou #{runtime.name} causando #{damage}."
    )

    FO_Debug.debug_log(
      "combat",
      "Auto attack em #{runtime.name}."
    )

  end

  def self.face_target(target)

    return unless FO_AutoAttackConfig::ENABLE_FACE_TARGET

    dx = target.x - $game_player.x

    dy = target.y - $game_player.y

    if dx.abs > dy.abs

      if dx > 0

        $game_player.turn_right

      else

        $game_player.turn_left

      end

    else

      if dy > 0

        $game_player.turn_down

      else

        $game_player.turn_up

      end

    end

  end

  def self.play_player_attack_animation

    return unless FO_AutoAttackConfig::ENABLE_PLAYER_ATTACK_ANIMATION

    $game_player.animation_id =
      FO_AutoAttackConfig::PLAYER_ATTACK_ANIMATION_ID

  end

  def self.play_target_hit_animation(target)

    return unless FO_AutoAttackConfig::ENABLE_TARGET_HIT_ANIMATION

    target.animation_id =
      FO_AutoAttackConfig::TARGET_HIT_ANIMATION_ID

  end

  def self.calculate_damage

    return FO_AutoAttackConfig::BASE_DAMAGE

  end

  def self.start_attack_cooldown

    @attack_timer = FO_AutoAttackConfig::ATTACK_SPEED

  end

  def self.reset

    @attack_timer = 0

  end

end

class Scene_Map

  alias fo_auto_attack_update update

  def update

    FO_AutoAttackSystem.update

    fo_auto_attack_update

  end

end

FO_Logger.action(
  "FO_AutoAttackSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "combat",
  "FO_AutoAttackSystem carregado."
)

FO_CORE.debug(
  "FO_AutoAttackSystem carregado com sucesso."
)