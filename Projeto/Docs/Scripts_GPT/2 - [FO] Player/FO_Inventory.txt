#==============================================================================
# ■ FO_Inventory
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 2.0.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema base de inventário do player.
#------------------------------------------------------------------------------
# Funções atuais:
# - Inventário por item_id
# - Integração com Database RMXP
# - Adicionar item
# - Remover item
# - Verificar item
# - Contar item
# - Stack básico
# - Limite de tipos de item
#==============================================================================

module FO_InventoryConfig

  MAX_ITEM_TYPES = 100

  ENABLE_LOG = true

end

module FO_Inventory

  @items = {}

  #===========================================================================
  # ■ setup
  #===========================================================================
  def self.setup

    @items = {}

    log_action(
      "Inventário inicializado."
    )

  end

  #===========================================================================
  # ■ items
  #===========================================================================
  def self.items

    return @items

  end

  #===========================================================================
  # ■ add_item
  #===========================================================================
  def self.add_item(item_id, amount = 1)

    return false if item_id.nil?

    return false if amount <= 0

    return false unless valid_item?(item_id)

    if new_item?(item_id)

      return false if full?

      @items[item_id] = 0

    end

    @items[item_id] += amount

    log_action(
      "Item adicionado: #{item_name(item_id)} x#{amount}. Total: #{@items[item_id]}"
    )

    return true

  end

  #===========================================================================
  # ■ add_item_by_name
  #===========================================================================
  def self.add_item_by_name(item_name, amount = 1)

    item_id = item_id_by_name(item_name)

    return false if item_id.nil?

    return add_item(item_id, amount)

  end

  #===========================================================================
  # ■ remove_item
  #===========================================================================
  def self.remove_item(item_id, amount = 1)

    return false if item_id.nil?

    return false if amount <= 0

    return false unless has_item?(item_id)

    return false if @items[item_id] < amount

    @items[item_id] -= amount

    if @items[item_id] <= 0

      @items.delete(item_id)

    end

    log_action(
      "Item removido: #{item_name(item_id)} x#{amount}."
    )

    return true

  end

  #===========================================================================
  # ■ remove_item_by_name
  #===========================================================================
  def self.remove_item_by_name(item_name, amount = 1)

    item_id = item_id_by_name(item_name)

    return false if item_id.nil?

    return remove_item(item_id, amount)

  end

  #===========================================================================
  # ■ has_item?
  #===========================================================================
  def self.has_item?(item_id)

    return false if item_id.nil?

    return @items.has_key?(item_id)

  end

  #===========================================================================
  # ■ has_item_by_name?
  #===========================================================================
  def self.has_item_by_name?(item_name)

    item_id = item_id_by_name(item_name)

    return false if item_id.nil?

    return has_item?(item_id)

  end

  #===========================================================================
  # ■ item_count
  #===========================================================================
  def self.item_count(item_id)

    return 0 if item_id.nil?

    return 0 unless has_item?(item_id)

    return @items[item_id]

  end

  #===========================================================================
  # ■ item_count_by_name
  #===========================================================================
  def self.item_count_by_name(item_name)

    item_id = item_id_by_name(item_name)

    return 0 if item_id.nil?

    return item_count(item_id)

  end

  #===========================================================================
  # ■ valid_item?
  #===========================================================================
  def self.valid_item?(item_id)

    return false unless defined?(FO_DatabaseBridge)

    return false if FO_DatabaseBridge.item(item_id).nil?

    return true

  end

  #===========================================================================
  # ■ item_name
  #===========================================================================
  def self.item_name(item_id)

    return "Unknown" unless defined?(FO_DatabaseBridge)

    name = FO_DatabaseBridge.item_name(item_id)

    return "Unknown" if name.nil?

    return name

  end

  #===========================================================================
  # ■ item_id_by_name
  #===========================================================================
  def self.item_id_by_name(item_name)

    return nil unless defined?(FO_DatabaseBridge)

    return FO_DatabaseBridge.item_id_by_name(item_name)

  end

  #===========================================================================
  # ■ full?
  #===========================================================================
  def self.full?

    return @items.keys.size >= FO_InventoryConfig::MAX_ITEM_TYPES

  end

  #===========================================================================
  # ■ empty?
  #===========================================================================
  def self.empty?

    return @items.empty?

  end

  #===========================================================================
  # ■ clear
  #===========================================================================
  def self.clear

    @items.clear

    log_action(
      "Inventário limpo."
    )

  end

  #===========================================================================
  # ■ new_item?
  #===========================================================================
  def self.new_item?(item_id)

    return !@items.has_key?(item_id)

  end

  #===========================================================================
  # ■ log_action
  #===========================================================================
  def self.log_action(message)

    return unless FO_InventoryConfig::ENABLE_LOG

    FO_Logger.action(message) if defined?(FO_Logger)

  end

  #===========================================================================
  # ■ debug_print
  #===========================================================================
  def self.debug_print

    FO_Logger.action(
      "===== INVENTÁRIO ====="
    ) if defined?(FO_Logger)

    if @items.empty?

      FO_Logger.action(
        "Inventário vazio."
      ) if defined?(FO_Logger)

      return

    end

    for item_id in @items.keys

      FO_Logger.action(
        "[#{item_id}] #{item_name(item_id)}: #{@items[item_id]}"
      ) if defined?(FO_Logger)

    end

  end

end

FO_Inventory.setup

FO_Logger.action(
  "FO_Inventory carregado com sucesso."
) if defined?(FO_Logger)

FO_Debug.debug_log(
  "player",
  "FO_Inventory carregado."
) if defined?(FO_Debug)

FO_CORE.debug(
  "FO_Inventory carregado com sucesso."
) if defined?(FO_CORE)