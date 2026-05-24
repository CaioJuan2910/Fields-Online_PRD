#==============================================================================
# ■ FO_PlayerRuntimeSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de runtime do player.
#------------------------------------------------------------------------------
# Funções atuais:
# - HP real
# - Dano
# - Cura
# - Morte
# - Regen
#==============================================================================

module FO_PlayerRuntimeConfig

  MAX_HP = 200

  ENABLE_REGEN = true

  REGEN_COOLDOWN = 120

  REGEN_VALUE = 5

end

module FO_PlayerRuntime

  @hp = FO_PlayerRuntimeConfig::MAX_HP

  @max_hp = FO_PlayerRuntimeConfig::MAX_HP

  @dead = false

  @regen_timer = 0

  class << self

    attr_accessor :hp
    attr_accessor :max_hp
    attr_accessor :dead
    attr_accessor :regen_timer

  end

  #===========================================================================
  # ■ update
  #===========================================================================
  def self.update

    update_regen_timer

    process_regen

  end

  #===========================================================================
  # ■ damage
  #===========================================================================
  def self.damage(value)

    return if @dead

    @hp -= value

    @hp = 0 if @hp < 0

    play_hit_animation

    show_damage(value)

    FO_Logger.action(
      "Player recebeu #{value} de dano. HP: #{@hp}/#{@max_hp}"
    )

    check_death

  end

  #===========================================================================
  # ■ heal
  #===========================================================================
  def self.heal(value)

    return if @dead

    @hp += value

    @hp = @max_hp if @hp > @max_hp

    FO_Logger.action(
      "Player recuperou #{value} HP. HP: #{@hp}/#{@max_hp}"
    )

  end

  #===========================================================================
  # ■ process_regen
  #===========================================================================
  def self.process_regen

    return unless FO_PlayerRuntimeConfig::ENABLE_REGEN

    return if @dead

    return if @hp >= @max_hp

    return if @regen_timer > 0

    heal(FO_PlayerRuntimeConfig::REGEN_VALUE)

    reset_regen_timer

  end

  #===========================================================================
  # ■ update_regen_timer
  #===========================================================================
  def self.update_regen_timer

    @regen_timer -= 1 if @regen_timer > 0

  end

  #===========================================================================
  # ■ reset_regen_timer
  #===========================================================================
  def self.reset_regen_timer

    @regen_timer =
      FO_PlayerRuntimeConfig::REGEN_COOLDOWN

  end

  #===========================================================================
  # ■ check_death
  #===========================================================================
  def self.check_death

    return if @hp > 0

    die

  end

  #===========================================================================
  # ■ die
  #===========================================================================
  def self.die

    return if @dead

    @dead = true

    FO_Logger.action(
      "Player morreu."
    )

  end

  #===========================================================================
  # ■ revive
  #===========================================================================
  def self.revive

    @dead = false

    @hp = @max_hp

    FO_Logger.action(
      "Player reviveu."
    )

  end

  #===========================================================================
  # ■ alive?
  #===========================================================================
  def self.alive?

    return !@dead

  end

  #===========================================================================
  # ■ dead?
  #===========================================================================
  def self.dead?

    return @dead

  end

  #===========================================================================
  # ■ hp_rate
  #===========================================================================
  def self.hp_rate

    return @hp.to_f / @max_hp.to_f

  end

  #===========================================================================
  # ■ play_hit_animation
  #===========================================================================
  def self.play_hit_animation

    $game_player.animation_id = 2

  end

  #===========================================================================
  # ■ show_damage
  #===========================================================================
  def self.show_damage(value)

    return unless defined?(FO_FloatingDamageManager)

    FO_FloatingDamageManager.show(
      $game_player,
      value
    )

  end

end

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map

  alias fo_player_runtime_update update

  #===========================================================================
  # ■ update
  #===========================================================================
  def update

    FO_PlayerRuntime.update

    fo_player_runtime_update

  end

end

#==============================================================================
# ■ Inicialização
#==============================================================================

FO_Logger.action(
  "FO_PlayerRuntimeSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "runtime",
  "FO_PlayerRuntimeSystem carregado."
)

FO_CORE.debug(
  "FO_PlayerRuntimeSystem carregado com sucesso."
)