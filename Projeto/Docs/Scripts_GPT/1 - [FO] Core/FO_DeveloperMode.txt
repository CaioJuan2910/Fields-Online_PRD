#==============================================================================
# ■ FO_DeveloperMode
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.1.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema central de desenvolvimento do projeto Fields Online.
#==============================================================================

module FO_DeveloperMode

  ENABLE_DEVELOPER_MODE = true

  ENABLE_CONSOLE_OUTPUT = false

  ENABLE_DEBUG_HUD = false

  ENABLE_TEST_SYSTEMS = false

  ENABLE_DEBUG_LOGS = true

  ENABLE_GM_MODE = false

  def self.console_output(message)

    return unless ENABLE_DEVELOPER_MODE

    return unless ENABLE_CONSOLE_OUTPUT

    print "#{message}\n"

  end

  def self.developer_mode?

    return ENABLE_DEVELOPER_MODE

  end

  def self.gm_mode?

    return ENABLE_GM_MODE

  end

end

FO_Logger.action(
  "FO_DeveloperMode carregado com sucesso."
) if defined?(FO_Logger)

FO_Debug.debug_log(
  "engine",
  "FO_DeveloperMode carregado."
) if defined?(FO_Debug)