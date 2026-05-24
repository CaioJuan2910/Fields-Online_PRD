#==============================================================================
# ■ FO_EnemySystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 18/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de monstros do projeto Fields Online.
#------------------------------------------------------------------------------
# Funções atuais:
# - Estrutura de inimigos
# - HP
# - Dano
# - Defesa
# - EXP
# - Gold
# - Drops
#------------------------------------------------------------------------------
#==============================================================================

class FO_Enemy

  #===========================================================================
  # ■ ATTR_ACCESSOR
  #===========================================================================

  attr_accessor :name

  attr_accessor :level

  attr_accessor :hp
  attr_accessor :max_hp

  attr_accessor :attack
  attr_accessor :defense

  attr_accessor :exp_reward
  attr_accessor :gold_reward

  attr_accessor :drops

  #===========================================================================
  # ■ initialize
  #===========================================================================
  def initialize(name = "Monster")

    @name = name

    setup_default_stats

    FO_Logger.action("Enemy criado: #{@name}")

    FO_Debug.debug_log("combat", "Enemy criado.")

  end

  #===========================================================================
  # ■ setup_default_stats
  #--------------------------------------------------------------------------
  # Define stats padrão.
  #===========================================================================
  def setup_default_stats

    @level = 1

    @max_hp = 100
    @hp     = @max_hp

    @attack  = 10
    @defense = 5

    @exp_reward  = 25
    @gold_reward = 10

    @drops = []

  end

  #===========================================================================
  # ■ attack_power
  #--------------------------------------------------------------------------
  # Retorna ataque do monstro.
  #===========================================================================
  def attack_power

    return @attack

  end

  #===========================================================================
  # ■ critical_chance
  #--------------------------------------------------------------------------
  # Chance de crítico do monstro.
  #===========================================================================
  def critical_chance

    return 3

  end

  #===========================================================================
  # ■ alive?
  #--------------------------------------------------------------------------
  # Verifica se está vivo.
  #===========================================================================
  def alive?

    return @hp > 0

  end

  #===========================================================================
  # ■ dead?
  #--------------------------------------------------------------------------
  # Verifica se morreu.
  #===========================================================================
  def dead?

    return @hp <= 0

  end

  #===========================================================================
  # ■ add_drop
  #--------------------------------------------------------------------------
  # Adiciona drop ao monstro.
  #
  # Estrutura:
  # {
  #   :item_id => 1,
  #   :chance  => 50
  # }
  #===========================================================================
  def add_drop(item_id, chance)

    drop_data = {
      :item_id => item_id,
      :chance  => chance
    }

    @drops.push(drop_data)

    FO_Logger.action(
      "#{@name} recebeu drop item #{item_id}"
    )

  end

  #===========================================================================
  # ■ generate_drops
  #--------------------------------------------------------------------------
  # Gera drops do monstro.
  #===========================================================================
  def generate_drops

    generated_drops = []

    for drop in @drops

      roll = rand(100)

      if roll < drop[:chance]

        generated_drops.push(drop[:item_id])

      end

    end

    return generated_drops

  end

  #===========================================================================
  # ■ reward_player
  #--------------------------------------------------------------------------
  # Recompensa jogador.
  #===========================================================================
  def reward_player(player)

    player.gain_exp(@exp_reward)

    player.gain_gold(@gold_reward)

    drops = generate_drops

    for item_id in drops

      item_name = FO_ItemDatabase.get_item_name(item_id)

      player.add_item(item_id, item_name, 1)

    end

    FO_Logger.action(
      "#{player.name} derrotou #{@name}"
    )

    FO_Debug.debug_log("combat", "Rewards aplicadas.")

  end

end

#==============================================================================
# ■ Inicialização
#==============================================================================

FO_Logger.action("FO_EnemySystem carregado com sucesso.")

FO_Debug.debug_log("combat", "FO_EnemySystem carregado.")

FO_CORE.debug("FO_EnemySystem carregado com sucesso.")