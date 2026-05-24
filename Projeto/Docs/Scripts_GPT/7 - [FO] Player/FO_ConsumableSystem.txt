#==============================================================================
# ■ FO_ConsumableSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de consumíveis do player.
#------------------------------------------------------------------------------
# Funções atuais:
# - Usar item consumível por ID
# - Usar item consumível por nome
# - Recuperar HP
# - Remover item do inventário
# - Integração com Database RMXP
# - Integração com FO_PlayerRuntime
#==============================================================================

module FO_ConsumableConfig

  ENABLE_CONSUMABLES = true

  ENABLE_LOG = true

  DEFAULT_POTION_HEAL = 50

end

module FO_ConsumableSystem

  #===========================================================================
  # ■ use_item
  #===========================================================================
  def self.use_item(item_id)

    return false unless FO_ConsumableConfig::ENABLE_CONSUMABLES

    return false if item_id.nil?

    return false unless inventory_ready?

    return false unless database_ready?

    return false unless player_runtime_ready?

    return false unless FO_Inventory.has_item?(item_id)

    item = FO_DatabaseBridge.item(item_id)

    return false if item.nil?

    return false unless consumable?(item)

    result = apply_item_effect(item)

    return false unless result

    FO_Inventory.remove_item(item_id, 1)

    log_action(
      "Player usou #{item.name} [ID #{item_id}]."
    )

    return true

  end

  #===========================================================================
  # ■ use_item_by_name
  #===========================================================================
  def self.use_item_by_name(item_name)

    return false if item_name.nil?

    return false unless database_ready?

    item_id = FO_DatabaseBridge.item_id_by_name(item_name)

    return false if item_id.nil?

    return use_item(item_id)

  end

  #===========================================================================
  # ■ consumable?
  #===========================================================================
  def self.consumable?(item)

    return false if item.nil?

    # No RMXP, itens consumíveis normalmente são RPG::Item.
    # Como estamos lendo de $data_items, já consideramos consumível.
    return true

  end

  #===========================================================================
  # ■ apply_item_effect
  #===========================================================================
  def self.apply_item_effect(item)

    return false if item.nil?

    heal_value = get_heal_value(item)

    if heal_value > 0

      FO_PlayerRuntime.heal(heal_value)

      log_action(
        "#{item.name} recuperou #{heal_value} HP."
      )

      return true

    end

    log_action(
      "#{item.name} não possui efeito configurado."
    )

    return false

  end

  #===========================================================================
  # ■ get_heal_value
  #===========================================================================
  def self.get_heal_value(item)

    return 0 if item.nil?

    if item.respond_to?(:recover_hp)

      return item.recover_hp if item.recover_hp > 0

    end

    if item.respond_to?(:recover_hp_rate)

      rate = item.recover_hp_rate

      if rate && rate > 0

        value = (FO_PlayerRuntime.max_hp * rate / 100).to_i

        return value

      end

    end

    if item.name.downcase == "potion"

      return FO_ConsumableConfig::DEFAULT_POTION_HEAL

    end

    return 0

  end

  #===========================================================================
  # ■ inventory_ready?
  #===========================================================================
  def self.inventory_ready?

    return defined?(FO_Inventory)

  end

  #===========================================================================
  # ■ database_ready?
  #===========================================================================
  def self.database_ready?

    return defined?(FO_DatabaseBridge)

  end

  #===========================================================================
  # ■ player_runtime_ready?
  #===========================================================================
  def self.player_runtime_ready?

    return defined?(FO_PlayerRuntime)

  end

  #===========================================================================
  # ■ log_action
  #===========================================================================
  def self.log_action(message)

    return unless FO_ConsumableConfig::ENABLE_LOG

    FO_Logger.action(message) if defined?(FO_Logger)

  end

  #===========================================================================
  # ■ test_use_first_item
  #===========================================================================
  def self.test_use_first_item

    return false unless inventory_ready?

    return false if FO_Inventory.items.empty?

    item_id = FO_Inventory.items.keys[0]

    return use_item(item_id)

  end

end

FO_Logger.action(
  "FO_ConsumableSystem carregado com sucesso."
) if defined?(FO_Logger)

FO_Debug.debug_log(
  "player",
  "FO_ConsumableSystem carregado."
) if defined?(FO_Debug)

FO_CORE.debug(
  "FO_ConsumableSystem carregado com sucesso."
) if defined?(FO_CORE)