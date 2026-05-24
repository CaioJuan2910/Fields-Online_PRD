#==============================================================================
# ■ FO_PlayerLevelSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de level e experiência do player.
#------------------------------------------------------------------------------
# Funções atuais:
# - Level do player
# - EXP atual
# - EXP para próximo level
# - Ganho de EXP
# - Level Up
# - Curva simples de progressão
#==============================================================================

module FO_PlayerLevelConfig

  START_LEVEL = 1

  START_EXP = 0

  MAX_LEVEL = 999

  BASE_NEXT_EXP = 100

  EXP_GROWTH_RATE = 2.0

  ENABLE_LEVEL_UP_LOG = true

  ENABLE_LEVEL_UP_SE = true

  LEVEL_UP_SE_NAME = "056-Right02"

  LEVEL_UP_SE_VOLUME = 80

  LEVEL_UP_SE_PITCH = 100

end

module FO_PlayerLevelSystem

  @level = FO_PlayerLevelConfig::START_LEVEL

  @exp = FO_PlayerLevelConfig::START_EXP

  class << self

    attr_accessor :level

    attr_accessor :exp

  end

  def self.setup

    @level = FO_PlayerLevelConfig::START_LEVEL

    @exp = FO_PlayerLevelConfig::START_EXP

    FO_Logger.action(
      "Player Level System inicializado."
    )

  end

  def self.gain_exp(value)

    return false if value.nil?

    return false if value <= 0

    return false if max_level?

    @exp += value

    FO_Logger.action(
      "Player recebeu #{value} EXP. EXP atual: #{@exp}/#{next_level_exp}"
    )

    check_level_up

    return true

  end

  def self.check_level_up

    while @exp >= next_level_exp && !max_level?

      required_exp = next_level_exp

      @exp -= required_exp

      level_up

    end

  end

  def self.level_up

    return if max_level?

    @level += 1

    @exp = 0 if max_level?

    play_level_up_sound

    FO_Logger.action(
      "Player subiu para o level #{@level}."
    ) if FO_PlayerLevelConfig::ENABLE_LEVEL_UP_LOG

  end

  def self.next_level_exp

    base = FO_PlayerLevelConfig::BASE_NEXT_EXP

    rate = FO_PlayerLevelConfig::EXP_GROWTH_RATE

    value = base * (rate ** (@level - 1))

    return value.to_i

  end

  def self.exp_rate

    return 1.0 if max_level?

    return 0.0 if next_level_exp <= 0

    return @exp.to_f / next_level_exp.to_f

  end

  def self.max_level?

    return @level >= FO_PlayerLevelConfig::MAX_LEVEL

  end

  def self.play_level_up_sound

    return unless FO_PlayerLevelConfig::ENABLE_LEVEL_UP_SE

    Audio.se_play(
      "Audio/SE/#{FO_PlayerLevelConfig::LEVEL_UP_SE_NAME}",
      FO_PlayerLevelConfig::LEVEL_UP_SE_VOLUME,
      FO_PlayerLevelConfig::LEVEL_UP_SE_PITCH
    )

  end

  def self.reset

    setup

  end

end

FO_PlayerLevelSystem.setup

FO_Logger.action(
  "FO_PlayerLevelSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "player",
  "FO_PlayerLevelSystem carregado."
)

FO_CORE.debug(
  "FO_PlayerLevelSystem carregado com sucesso."
)