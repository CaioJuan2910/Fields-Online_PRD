#==============================================================================
# ■ FO_AISystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 18/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de IA dos monstros do projeto Fields Online.
#------------------------------------------------------------------------------
# Funções atuais:
# - Detecção de alvo
# - Chase System
# - Movimento básico
# - Retorno ao spawn
#------------------------------------------------------------------------------
#==============================================================================

module FO_AISystem

  #===========================================================================
  # ■ CONFIGURAÇÕES
  #===========================================================================

  AGGRO_RANGE  = 5

  ATTACK_RANGE = 1

  RETURN_RANGE = 10

  #===========================================================================
  # ■ update_enemy_ai
  #--------------------------------------------------------------------------
  # Atualiza IA do monstro.
  #===========================================================================
  def self.update_enemy_ai(enemy, player)

    return if enemy.dead?

    if enemy.target.nil?

      detect_target(enemy, player)

    else

      process_target(enemy)

    end

  end

  #===========================================================================
  # ■ detect_target
  #--------------------------------------------------------------------------
  # Detecta alvo.
  #===========================================================================
  def self.detect_target(enemy, player)

    distance = FO_TargetSystem.distance(enemy, player)

    if distance <= AGGRO_RANGE

      enemy.target = player

      enemy.aggressive = true

      FO_Logger.action(
        "#{enemy.name} detectou #{player.name}"
      )

      FO_Debug.debug_log("combat", "Target detectado.")

    end

  end

  #===========================================================================
  # ■ process_target
  #--------------------------------------------------------------------------
  # Processa target atual.
  #===========================================================================
  def self.process_target(enemy)

    target = enemy.target

    unless FO_TargetSystem.valid_target?(target)

      reset_enemy(enemy)

      return

    end

    distance = FO_TargetSystem.distance(enemy, target)

    if distance <= ATTACK_RANGE

      attack_target(enemy, target)

    else

      chase_target(enemy, target)

    end

    check_return(enemy)

  end

  #===========================================================================
  # ■ attack_target
  #--------------------------------------------------------------------------
  # Ataca alvo.
  #===========================================================================
  def self.attack_target(enemy, target)

    FO_CombatSystem.attack(enemy, target)

    FO_Debug.debug_log("combat", "Enemy attack executado.")

  end

  #===========================================================================
  # ■ chase_target
  #--------------------------------------------------------------------------
  # Persegue alvo.
  #===========================================================================
  def self.chase_target(enemy, target)

    if enemy.x < target.x
      enemy.x += 1
    elsif enemy.x > target.x
      enemy.x -= 1
    end

    if enemy.y < target.y
      enemy.y += 1
    elsif enemy.y > target.y
      enemy.y -= 1
    end

    FO_Debug.debug_log("combat", "Enemy moving.")

  end

  #===========================================================================
  # ■ check_return
  #--------------------------------------------------------------------------
  # Verifica retorno ao spawn.
  #===========================================================================
  def self.check_return(enemy)

    dx = (enemy.x - enemy.spawn_x).abs

    dy = (enemy.y - enemy.spawn_y).abs

    distance = dx + dy

    if distance > RETURN_RANGE

      reset_enemy(enemy)

    end

  end

  #===========================================================================
  # ■ reset_enemy
  #--------------------------------------------------------------------------
  # Reseta comportamento do monstro.
  #===========================================================================
  def self.reset_enemy(enemy)

    enemy.target = nil

    enemy.aggressive = false

    enemy.x = enemy.spawn_x
    enemy.y = enemy.spawn_y

    FO_Logger.action(
      "#{enemy.name} retornou ao spawn."
    )

    FO_Debug.debug_log("combat", "Enemy resetado.")

  end

end

#==============================================================================
# ■ Expansão do FO_Enemy
#==============================================================================

class FO_Enemy

  attr_accessor :target

  attr_accessor :aggressive

  attr_accessor :spawn_x
  attr_accessor :spawn_y

end

#==============================================================================
# ■ Expansão do initialize
#==============================================================================

class FO_Enemy

  alias fo_ai_initialize initialize

  #===========================================================================
  # ■ initialize
  #===========================================================================
  def initialize(name = "Monster")

    fo_ai_initialize(name)

    @target = nil

    @aggressive = false

    @spawn_x = 0
    @spawn_y = 0

  end

end

#==============================================================================
# ■ Inicialização
#==============================================================================

FO_Logger.action("FO_AISystem carregado com sucesso.")

FO_Debug.debug_log("combat", "FO_AISystem carregado.")

FO_CORE.debug("FO_AISystem carregado com sucesso.")