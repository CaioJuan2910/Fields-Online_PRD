#==============================================================================
# ■ FO_Utils
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.1
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de utilidades globais do projeto Fields Online.
#==============================================================================

module FO_Utils

  def self.format_number(value)

    value.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse

  end

  def self.valid_name?(name)

    return false if name.nil?

    return false if name.size < 3

    return false if name.size > 16

    regex = /^[A-Za-z0-9]+$/

    return false unless name =~ regex

    return true

  end

  def self.clamp(value, min, max)

    return min if value < min

    return max if value > max

    return value

  end

  def self.seconds_to_time(seconds)

    hours = seconds / 3600

    minutes = (seconds % 3600) / 60

    secs = seconds % 60

    return sprintf(
      "%02d:%02d:%02d",
      hours,
      minutes,
      secs
    )

  end

end

FO_Logger.action(
  "FO_Utils carregado com sucesso."
) if defined?(FO_Logger)