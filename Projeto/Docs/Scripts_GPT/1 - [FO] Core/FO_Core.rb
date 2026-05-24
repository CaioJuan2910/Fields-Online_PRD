#==============================================================================
# ■ FO_Core
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.3
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Núcleo base do projeto Fields Online.
#==============================================================================

module FO_CORE

  GAME_NAME    = "Fields Online"

  GAME_VERSION = "1.0.3"

  GAME_AUTHOR  = "Caio & ChatGPT"

  DEBUG_MODE = true

  def self.debug(message)

    return unless DEBUG_MODE

  end

end