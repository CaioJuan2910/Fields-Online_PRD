#==============================================================================
# ■ FO_Inventory
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema base de inventário do player.
#------------------------------------------------------------------------------
# Funções atuais:
# - Adicionar item
# - Remover item
# - Verificar item
# - Contar item
# - Stack básico
# - Limite de tipos de item
# - Integração com Loot System
#==============================================================================

module FO_InventoryConfig

  MAX_ITEM_TYPES = 100

  ENABLE_LOG = true

end

module FO_Inventory

  @items = {}

  def self.setup

    @items = {}

    FO_Logger.action(
      "Inventário inicializado."
    )

  end

  def self.items

    return @items

  end

  def self.add_item(item_name, amount = 1)

    return false if item_name.nil?

    return false if amount <= 0

    if new_item?(item_name)

      return false if full?

      @items[item_name] = 0

    end

    @items[item_name] += amount

    log_action(
      "Item adicionado: #{item_name} x#{amount}. Total: #{@items[item_name]}"
    )

    return true

  end

  def self.remove_item(item_name, amount = 1)

    return false if item_name.nil?

    return false if amount <= 0

    return false unless has_item?(item_name)

    return false if @items[item_name] < amount

    @items[item_name] -= amount

    if @items[item_name] <= 0

      @items.delete(item_name)

    end

    log_action(
      "Item removido: #{item_name} x#{amount}."
    )

    return true

  end

  def self.has_item?(item_name)

    return false if item_name.nil?

    return @items.has_key?(item_name)

  end

  def self.item_count(item_name)

    return 0 if item_name.nil?

    return 0 unless has_item?(item_name)

    return @items[item_name]

  end

  def self.full?

    return @items.keys.size >= FO_InventoryConfig::MAX_ITEM_TYPES

  end

  def self.empty?

    return @items.empty?

  end

  def self.clear

    @items.clear

    log_action(
      "Inventário limpo."
    )

  end

  def self.new_item?(item_name)

    return !@items.has_key?(item_name)

  end

  def self.log_action(message)

    return unless FO_InventoryConfig::ENABLE_LOG

    FO_Logger.action(message)

  end

  def self.debug_print

    FO_Logger.action(
      "===== INVENTÁRIO ====="
    )

    if @items.empty?

      FO_Logger.action(
        "Inventário vazio."
      )

      return

    end

    for item_name in @items.keys

      FO_Logger.action(
        "#{item_name}: #{@items[item_name]}"
      )

    end

  end

end

FO_Inventory.setup

FO_Logger.action(
  "FO_Inventory carregado com sucesso."
)

FO_Debug.debug_log(
  "player",
  "FO_Inventory carregado."
)

FO_CORE.debug(
  "FO_Inventory carregado com sucesso."
)