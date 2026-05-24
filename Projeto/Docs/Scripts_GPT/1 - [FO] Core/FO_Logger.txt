#==============================================================================
# ■ FO_Logger
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.1.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de logs do projeto Fields Online.
#==============================================================================

module FO_Logger

  LOG_FOLDER = "Logs"

  def self.create_log_folder

    unless FileTest.exist?(LOG_FOLDER)
      Dir.mkdir(LOG_FOLDER)
    end

  end

  def self.current_date

    time = Time.now

    return sprintf(
      "%04d_%02d_%02d",
      time.year,
      time.month,
      time.day
    )

  end

  def self.current_time

    time = Time.now

    return sprintf(
      "%02d:%02d:%02d",
      time.hour,
      time.min,
      time.sec
    )

  end

  def self.log_enabled?(type)

    return true unless defined?(FO_Settings)

    case type

    when "erros"

      return FO_Settings::ENABLE_ERROR_LOG

    when "acoes"

      return FO_Settings::ENABLE_ACTION_LOG

    when "chat"

      return FO_Settings::ENABLE_CHAT_LOG

    when "network"

      return FO_Settings::ENABLE_NETWORK_LOG

    end

    return true

  end

  def self.log(type, message)

    return unless log_enabled?(type)

    begin

      create_log_folder

      file_name = "fo_log_#{type}_#{current_date}.txt"

      file_path = "#{LOG_FOLDER}/#{file_name}"

      file = File.open(file_path, "a")

      file.write("[#{current_time}] #{message}\n")

      file.close

      if defined?(FO_CORE)
        FO_CORE.debug("[LOGGER] #{message}")
      end

    rescue

    end

  end

  def self.error(message)

    log("erros", message)

  end

  def self.action(message)

    log("acoes", message)

  end

  def self.chat(message)

    log("chat", message)

  end

  def self.network(message)

    log("network", message)

  end

end

FO_Logger.create_log_folder

FO_Logger.action(
  "FO_Logger carregado com sucesso."
)