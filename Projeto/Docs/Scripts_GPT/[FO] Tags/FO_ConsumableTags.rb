#==============================================================================
# ■ FO_ConsumableTags
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 24/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de leitura de NOTE TAGS para consumíveis.
#------------------------------------------------------------------------------
# Funções:
# - Ler heal_hp
# - Ler heal_mp
# - Verificar existência de tags
# - Compatível com RMXP Database
#==============================================================================

module FO_ConsumableTags

  #===========================================================================
  # ■ heal_hp
  #===========================================================================
  def self.heal_hp(item)

    return 0 if item.nil?

    note = get_note(item)

    result = note.match(/<heal_hp:(\d+)>/i)

    return 0 if result.nil?

    return result[1].to_i

  end

  #===========================================================================
  # ■ heal_mp
  #===========================================================================
  def self.heal_mp(item)

    return 0 if item.nil?

    note = get_note(item)

    result = note.match(/<heal_mp:(\d+)>/i)

    return 0 if result.nil?

    return result[1].to_i

  end

  #===========================================================================
  # ■ has_heal_hp?
  #===========================================================================
  def self.has_heal_hp?(item)

    return heal_hp(item) > 0

  end

  #===========================================================================
  # ■ has_heal_mp?
  #===========================================================================
  def self.has_heal_mp?(item)

    return heal_mp(item) > 0

  end

  #===========================================================================
  # ■ get_note
  #===========================================================================
  def self.get_note(item)

    return "" if item.nil?

    if item.respond_to?(:note)

      return item.note.to_s

    end

    return ""

  end

  #===========================================================================
  # ■ debug_item
  #===========================================================================
  def self.debug_item(item)

    return if item.nil?

    hp = heal_hp(item)
    mp = heal_mp(item)

    log("===== TAG DEBUG =====")
    log("Item: #{item.name}")
    log("Heal HP: #{hp}")
    log("Heal MP: #{mp}")
    log("=====================")

  end

  #===========================================================================
  # ■ log
  #===========================================================================
  def self.log(message)

    if defined?(FO_Logger)

      FO_Logger.action(message)

    elsif defined?(FO_Debug)

      FO_Debug.debug_log("consumable_tags", message)

    elsif defined?(FO_CORE)

      FO_CORE.debug(message)

    end

  end

end

FO_ConsumableTags.log(
  "FO_ConsumableTags carregado com sucesso."
)