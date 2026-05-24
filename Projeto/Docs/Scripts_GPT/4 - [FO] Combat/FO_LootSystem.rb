#==============================================================================
# ■ FO_LootSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 2.1.0
# Data......: 24/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de loot/drop dos mobs com integração de EXP.
#------------------------------------------------------------------------------
# Funções atuais:
# - Drop por item_id do Database RMXP
# - Chance percentual
# - Integração com FO_Inventory v2
# - Floating Loot
# - Log de drops
# - Ganho de EXP ao matar Mob/Boss
# - Integração com FO_PlayerLevelSystem
#==============================================================================

module FO_LootConfig

  ENABLE_LOOT = true
  ENABLE_LOOT_LOG = true
  ENABLE_FLOATING_LOOT = true

  ENABLE_EXP_REWARD = true
  ENABLE_EXP_LOG = true

  DEFAULT_EXP_REWARD = 10

  EXP_REWARDS = {
    "Ghost" => 25,
    "DragonBoss" => 250
  }

  DEFAULT_LOOT_TABLE = [
    [1, 50],
    [2, 50]
  ]

  LOOT_TABLES = {

    "Ghost" => [
      [1, 50],
      [2, 50]
    ],

    "DragonBoss" => [
      [1, 50],
      [2, 50]
    ]

  }

end

module FO_LootSystem

  @processed_runtime_ids = []

  def self.update
    return unless defined?(FO_EntityRuntimeManager)
    return if FO_EntityRuntimeManager.runtimes.nil?

    for runtime in FO_EntityRuntimeManager.runtimes
      next if runtime.nil?
      update_runtime_loot(runtime)
    end
  end

  def self.update_runtime_loot(runtime)
    if runtime.dead?
      process_death_rewards_once(runtime)
    else
      clear_processed_runtime(runtime)
    end
  end

  def self.process_death_rewards_once(runtime)
    return if loot_already_processed?(runtime)

    mark_loot_processed(runtime)

    process_loot(runtime)
    process_exp_reward(runtime)
  end

  def self.loot_already_processed?(runtime)
    return @processed_runtime_ids.include?(runtime.runtime_id)
  end

  def self.mark_loot_processed(runtime)
    @processed_runtime_ids.push(runtime.runtime_id)
  end

  def self.clear_processed_runtime(runtime)
    @processed_runtime_ids.delete(runtime.runtime_id)
  end

  def self.process_loot(runtime)
    return false unless FO_LootConfig::ENABLE_LOOT
    return false if runtime.nil?
    return false unless loot_entity?(runtime)

    table = loot_table(runtime)
    drops = roll_loot(table)

    show_floating_loot(runtime, drops)
    register_drops(runtime, drops)

    return true
  end

  def self.process_exp_reward(runtime)
    return false unless FO_LootConfig::ENABLE_EXP_REWARD
    return false if runtime.nil?
    return false unless loot_entity?(runtime)
    return false unless defined?(FO_PlayerLevelSystem)
    return false unless FO_PlayerLevelSystem.respond_to?(:gain_exp)

    exp = exp_reward(runtime)

    return false if exp.nil?
    return false if exp <= 0

    FO_PlayerLevelSystem.gain_exp(exp)

    FO_Logger.action(
      "#{runtime.name} concedeu #{exp} EXP ao Player."
    ) if FO_LootConfig::ENABLE_EXP_LOG && defined?(FO_Logger)

    return true
  end

  def self.exp_reward(runtime)
    reward = FO_LootConfig::EXP_REWARDS[runtime.name]
    return reward if reward
    return FO_LootConfig::DEFAULT_EXP_REWARD
  end

  def self.loot_entity?(runtime)
    return true if runtime.entity_type == :mob
    return true if runtime.entity_type == :boss
    return false
  end

  def self.loot_table(runtime)
    name = runtime.name
    table = FO_LootConfig::LOOT_TABLES[name]

    return table if table
    return FO_LootConfig::DEFAULT_LOOT_TABLE
  end

  def self.roll_loot(table)
    drops = []

    for loot_data in table
      item_id = loot_data[0]
      chance = loot_data[1]

      next unless valid_item?(item_id)

      chance = 0 if chance < 0
      chance = 100 if chance > 100

      roll = rand(100) + 1

      if roll <= chance
        drops.push(item_id)
      end
    end

    return drops
  end

  def self.valid_item?(item_id)
    return false unless defined?(FO_DatabaseBridge)
    return false if FO_DatabaseBridge.item(item_id).nil?
    return true
  end

  def self.item_name(item_id)
    return "Unknown" unless defined?(FO_DatabaseBridge)

    name = FO_DatabaseBridge.item_name(item_id)

    return "Unknown" if name.nil?
    return name
  end

  def self.show_floating_loot(runtime, drops)
    return unless FO_LootConfig::ENABLE_FLOATING_LOOT
    return if drops.nil?
    return if drops.empty?
    return unless defined?(FO_FloatingLootManager)

    names = []

    for item_id in drops
      names.push(item_name(item_id))
    end

    FO_FloatingLootManager.show_multiple(
      runtime.event,
      names
    )
  end

  def self.register_drops(runtime, drops)
    if drops.empty?
      FO_Logger.action(
        "#{runtime.name} não dropou nenhum item."
      ) if FO_LootConfig::ENABLE_LOOT_LOG && defined?(FO_Logger)

      return
    end

    for item_id in drops
      give_item_to_player(item_id)

      FO_Logger.action(
        "#{runtime.name} dropou: #{item_name(item_id)} [ID #{item_id}]"
      ) if FO_LootConfig::ENABLE_LOOT_LOG && defined?(FO_Logger)
    end
  end

  def self.give_item_to_player(item_id)
    if defined?(FO_Inventory)
      if FO_Inventory.respond_to?(:add_item)
        FO_Inventory.add_item(item_id, 1)
        return true
      end
    end

    FO_Logger.action(
      "Loot recebido: #{item_name(item_id)} [ID #{item_id}]"
    ) if defined?(FO_Logger)

    return true
  end

  def self.reset
    @processed_runtime_ids.clear
  end

end

class Scene_Map

  alias fo_loot_system_update update

  def update
    FO_LootSystem.update
    fo_loot_system_update
  end

end

FO_Logger.action(
  "FO_LootSystem carregado com sucesso."
) if defined?(FO_Logger)

FO_Debug.debug_log(
  "combat",
  "FO_LootSystem carregado."
) if defined?(FO_Debug)

FO_CORE.debug(
  "FO_LootSystem carregado com sucesso."
) if defined?(FO_CORE)