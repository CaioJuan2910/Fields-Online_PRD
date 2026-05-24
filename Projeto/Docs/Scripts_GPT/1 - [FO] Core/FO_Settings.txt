#==============================================================================
# ■ FO_Settings
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.1.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema central de configurações do projeto Fields Online.
#------------------------------------------------------------------------------
# IMPORTANTE:
# Este script NÃO depende de FO_Logger e NÃO depende de FO_Debug.
#==============================================================================

module FO_Settings

  SERVER_NAME        = "Fields Online"
  SERVER_IP          = "127.0.0.1"
  SERVER_PORT        = 4000
  SERVER_VERSION     = "0.1.0"

  SCREEN_WIDTH       = 640
  SCREEN_HEIGHT      = 480
  FULLSCREEN         = false
  TARGET_FPS         = 60

  ENABLE_DEBUG       = true
  ENABLE_CONSOLE_LOG = false

  ENABLE_ERROR_LOG   = true
  ENABLE_ACTION_LOG  = true
  ENABLE_CHAT_LOG    = true
  ENABLE_NETWORK_LOG = true

  MAX_PLAYERS        = 100
  MAX_LEVEL          = 999
  MAX_GOLD           = 999999999

  ENABLE_PVP         = true
  ENABLE_PARTY       = true
  ENABLE_GUILD       = true

  def self.show_settings

    return unless defined?(FO_CORE)

    FO_CORE.debug("========================================")
    FO_CORE.debug("FIELDS ONLINE SETTINGS")
    FO_CORE.debug("========================================")
    FO_CORE.debug("Servidor : #{SERVER_NAME}")
    FO_CORE.debug("IP        : #{SERVER_IP}")
    FO_CORE.debug("Porta     : #{SERVER_PORT}")
    FO_CORE.debug("Versão    : #{SERVER_VERSION}")
    FO_CORE.debug("========================================")

  end

end

FO_Settings.show_settings