#==============================================================================
# ■ FO_ItemDatabase
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.1
# Data......: 18/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de integração com Items do Database do RMXP.
#------------------------------------------------------------------------------
# Funções atuais:
# - Leitura de itens do RMXP
# - Busca por ID
# - Busca por nome
# - Informações formatadas
# - Validação de segurança
#------------------------------------------------------------------------------
#==============================================================================

module FO_ItemDatabase

  #===========================================================================
  # ■ database_loaded?
  #--------------------------------------------------------------------------
  # Verifica se o database do RMXP foi carregado.
  #===========================================================================
  def self.database_loaded?

    if $data_items.nil?

      FO_Logger.error("Database Items não carregado.")

      FO_Debug.debug_log(
        "engine",
        "$data_items está nil."
      )

      return false

    end

    return true

  end

  #===========================================================================
  # ■ get_item
  #--------------------------------------------------------------------------
  # Retorna item pelo ID.
  #===========================================================================
  def self.get_item(item_id)

    return nil unless database_loaded?

    item = $data_items[item_id]

    if item.nil?

      FO_Logger.error("Item ID #{item_id} não encontrado.")

      return nil

    end

    return item

  end

  #===========================================================================
  # ■ get_item_name
  #--------------------------------------------------------------------------
  # Retorna nome do item.
  #===========================================================================
  def self.get_item_name(item_id)

    item = get_item(item_id)

    return "" if item.nil?

    return item.name

  end

  #===========================================================================
  # ■ get_item_description
  #--------------------------------------------------------------------------
  # Retorna descrição do item.
  #===========================================================================
  def self.get_item_description(item_id)

    item = get_item(item_id)

    return "" if item.nil?

    return item.description

  end

  #===========================================================================
  # ■ get_item_price
  #--------------------------------------------------------------------------
  # Retorna preço do item.
  #===========================================================================
  def self.get_item_price(item_id)

    item = get_item(item_id)

    return 0 if item.nil?

    return item.price

  end

  #===========================================================================
  # ■ find_item_by_name
  #--------------------------------------------------------------------------
  # Busca item pelo nome.
  #===========================================================================
  def self.find_item_by_name(item_name)

    return nil unless database_loaded?

    for item in $data_items

      next if item.nil?

      if item.name.downcase == item_name.downcase

        return item

      end

    end

    FO_Logger.error("Item '#{item_name}' não encontrado.")

    return nil

  end

  #===========================================================================
  # ■ show_item_info
  #--------------------------------------------------------------------------
  # Exibe informações do item.
  #===========================================================================
  def self.show_item_info(item_id)

    item = get_item(item_id)

    return if item.nil?

    print "\n"
    print "========================================\n"
    print "ITEM DATABASE\n"
    print "========================================\n"

    print "ID..........: #{item.id}\n"
    print "Nome........: #{item.name}\n"
    print "Descrição...: #{item.description}\n"
    print "Preço.......: #{item.price}\n"

    print "========================================\n"
    print "\n"

    FO_Logger.action(
      "Informações do item #{item.id} exibidas."
    )

  end

end

#==============================================================================
# ■ Inicialização
#==============================================================================

FO_Logger.action("FO_ItemDatabase carregado com sucesso.")

FO_Debug.debug_log("engine", "FO_ItemDatabase carregado.")

FO_CORE.debug("FO_ItemDatabase carregado com sucesso.")