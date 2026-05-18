#==============================================================================
# ■ FO_CombatSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 18/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de combate do projeto Fields Online.
#------------------------------------------------------------------------------
# Funções atuais:
# - Ataque
# - Dano
# - Crítico
# - Miss
# - Morte
#------------------------------------------------------------------------------
#==============================================================================

module FO_CombatSystem

  #===========================================================================
  # ■ CONFIGURAÇÕES
  #===========================================================================

  CRITICAL_DAMAGE_MULTIPLIER = 2.0

  BASE_MISS_CHANCE           = 5

  #===========================================================================
  # ■ calculate_damage
  #--------------------------------------------------------------------------
  # Calcula dano do atacante contra defensor.
  #===========================================================================
  def self.calculate_damage(attacker, target)

    attack = attacker.attack_power

    defense = target.defense

    base_damage = attack - (defense / 2)

    if base_damage < 1
      base_damage = 1
    end

    critical = critical_hit?(attacker)

    if critical

      base_damage *= CRITICAL_DAMAGE_MULTIPLIER

    end

    base_damage = base_damage.to_i

    return {
      :damage   => base_damage,
      :critical => critical
    }

  end

  #===========================================================================
  # ■ critical_hit?
  #--------------------------------------------------------------------------
  # Verifica crítico.
  #===========================================================================
  def self.critical_hit?(attacker)

    chance = attacker.critical_chance

    roll = rand(100)

    return roll < chance

  end

  #===========================================================================
  # ■ miss_attack?
  #--------------------------------------------------------------------------
  # Verifica miss.
  #===========================================================================
  def self.miss_attack?

    roll = rand(100)

    return roll < BASE_MISS_CHANCE

  end

  #===========================================================================
  # ■ attack
  #--------------------------------------------------------------------------
  # Executa ataque.
  #===========================================================================
  def self.attack(attacker, target)

    if miss_attack?

      FO_Logger.action(
        "#{attacker.name} errou o ataque."
      )

      FO_Debug.debug_log("combat", "Miss executado.")

      return {
        :result => :miss,
        :damage => 0
      }

    end

    result = calculate_damage(attacker, target)

    damage = result[:damage]

    critical = result[:critical]

    target.hp -= damage

    if target.hp < 0
      target.hp = 0
    end

    if critical

      FO_Logger.action(
        "#{attacker.name} causou CRÍTICO em #{target.name} (#{damage})"
      )

    else

      FO_Logger.action(
        "#{attacker.name} atacou #{target.name} (#{damage})"
      )

    end

    FO_Debug.debug_log("combat", "Dano aplicado.")

    dead = target_dead?(target)

    return {
      :result   => :hit,
      :damage   => damage,
      :critical => critical,
      :dead     => dead
    }

  end

  #===========================================================================
  # ■ target_dead?
  #--------------------------------------------------------------------------
  # Verifica morte.
  #===========================================================================
  def self.target_dead?(target)

    if target.hp <= 0

      FO_Logger.action(
        "#{target.name} morreu."
      )

      FO_Debug.debug_log("combat", "Target morto.")

      return true

    end

    return false

  end

end

#==============================================================================
# ■ Inicialização
#==============================================================================

FO_Logger.action("FO_CombatSystem carregado com sucesso.")

FO_Debug.debug_log("combat", "FO_CombatSystem carregado.")

FO_CORE.debug("FO_CombatSystem carregado com sucesso.")