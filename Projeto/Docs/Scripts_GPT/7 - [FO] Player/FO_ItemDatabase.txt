#==============================================================================
# ■ FO_ItemDatabase
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Banco de dados principal de itens do jogo.
#------------------------------------------------------------------------------
# Funções atuais:
# - Database de itens
# - Busca por ID
# - Busca por nome
# - Preparação consumíveis
# - Preparação equipamentos
#==============================================================================

module FO_ItemDatabase

  ITEMS = {

    1 => {
      :id => 1,
      :name => "Gold",
      :description => "Moeda principal do jogo.",
      :icon => "icon_gold",
      :type => :currency,
      :stack_limit => 999999,
      :sell_value => 1
    },

    2 => {
      :id => 2,
      :name => "Potion",
      :description => "Recupera 50 HP.",
      :icon => "icon_potion",
      :type => :consumable,
      :stack_limit => 99,
      :sell_value => 25,
      :heal_hp => 50
    },

    3 => {
      :id => 3,
      :name => "Ghost Essence",
      :description => "Essência espiritual de um Ghost.",
      :icon => "icon_ghost_essence",
      :type => :material,
      :stack_limit => 99,
      :sell_value => 80
    },

    4 => {
      :id => 4,
      :name => "Dragon Scale",
      :description => "Escama rara de dragão.",
      :icon => "icon_dragon_scale",
      :type => :material,
      :stack_limit => 99,
      :sell_value => 250
    },

    5 => {
      :id => 5,
      :name => "Dragon Core",
      :description => "Núcleo mágico de um dragão.",
      :icon => "icon_dragon_core",
      :type => :rare_material,
      :stack_limit => 10,
      :sell_value => 1000
    }

  }

  #===========================================================================
  # ■ item
  #===========================================================================
  def self.item(item_id)

    return ITEMS[item_id]

  end

  #===========================================================================
  # ■ item_by_name
  #===========================================================================
  def self.item_by_name(name)

    for item_id in ITEMS.keys

      item_data = ITEMS[item_id]

      next if item_data.nil?

      return item_data if item_data[:name] == name

    end

    return nil

  end

  #===========================================================================
  # ■ exists?
  #===========================================================================
  def self.exists?(item_id)

    return ITEMS.has_key?(item_id)

  end

  #===========================================================================
  # ■ exists_name?
  #===========================================================================
  def self.exists_name?(name)

    return !item_by_name(name).nil?

  end

  #===========================================================================
  # ■ item_name
  #===========================================================================
  def self.item_name(item_id)

    item_data = item(item_id)

    return nil if item_data.nil?

    return item_data[:name]

  end

  #===========================================================================
  # ■ item_type
  #===========================================================================
  def self.item_type(item_id)

    item_data = item(item_id)

    return nil if item_data.nil?

    return item_data[:type]

  end

  #===========================================================================
  # ■ stack_limit
  #===========================================================================
  def self.stack_limit(item_id)

    item_data = item(item_id)

    return 0 if item_data.nil?

    return item_data[:stack_limit]

  end

  #===========================================================================
  # ■ consumable?
  #===========================================================================
  def self.consumable?(item_id)

    item_data = item(item_id)

    return false if item_data.nil?

    return item_data[:type] == :consumable

  end

  #===========================================================================
  # ■ equipment?
  #===========================================================================
  def self.equipment?(item_id)

    item_data = item(item_id)

    return false if item_data.nil?

    return item_data[:type] == :equipment

  end

  #===========================================================================
  # ■ debug_print
  #===========================================================================
  def self.debug_print

    FO_Logger.action(
      "===== ITEM DATABASE ====="
    )

    for item_id in ITEMS.keys

      item_data = ITEMS[item_id]

      FO_Logger.action(
        "[#{item_id}] #{item_data[:name]}"
      )

    end

  end

end

FO_Logger.action(
  "FO_ItemDatabase carregado com sucesso."
)

FO_Debug.debug_log(
  "player",
  "FO_ItemDatabase carregado."
)

FO_CORE.debug(
  "FO_ItemDatabase carregado com sucesso."
)