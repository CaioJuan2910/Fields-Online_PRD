#==============================================================================
# ■ FO_EntityRuntimeSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.5.1
# Data......: 20/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema responsável pelo runtime das entidades MMORPG.
#------------------------------------------------------------------------------
# Funções atuais:
# - HP real
# - Dano
# - Cura
# - Morte visual
# - Respawn automático
# - Respawn aleatório pelo mapa
# - Limpeza de target ao morrer
#==============================================================================

module FO_EntityRuntimeConfig

  RANDOM_RESPAWN = true

  RESPAWN_TIME = 300

  RANDOM_RESPAWN_ATTEMPTS = 80

  RESPAWN_MAP_MARGIN = 1

end

class FO_EntityRuntime

  attr_accessor :runtime_id
  attr_accessor :map_id
  attr_accessor :event_id
  attr_accessor :event
  attr_accessor :entity_type
  attr_accessor :name
  attr_accessor :hp
  attr_accessor :max_hp
  attr_accessor :alive
  attr_accessor :respawn_time
  attr_accessor :respawn_counter

  def initialize(entity_data)

    @runtime_id = rand(999999)
    @map_id = $game_map.map_id
    @event = entity_data[:event]
    @event_id = @event.id
    @entity_type = entity_data[:type]

    setup_name
    setup_stats
    setup_state

    FO_Logger.action(
      "Runtime criado: #{@name}"
    )

  end

  def setup_name

    original_name = @event.event.name

    @name = original_name[1..original_name.size]

  end

  def setup_stats

    case @entity_type

    when :boss

      @max_hp = 500

    when :mob

      @max_hp = 100

    else

      @max_hp = 1

    end

    @hp = @max_hp

  end

  def setup_state

    @alive = true

    @respawn_time = FO_EntityRuntimeConfig::RESPAWN_TIME

    @respawn_counter = 0

  end

  def alive?

    return @alive

  end

  def dead?

    return !@alive

  end

  def damage(value)

    return unless @alive

    @hp -= value

    @hp = 0 if @hp < 0

    if defined?(FO_FloatingDamageManager)

      FO_FloatingDamageManager.show(
        @event,
        value
      )

    end

    FO_Logger.action(
      "#{@name} recebeu #{value} de dano. HP: #{@hp}/#{@max_hp}"
    )

    check_death

  end

  def heal(value)

    return unless @alive

    @hp += value

    @hp = @max_hp if @hp > @max_hp

    FO_Logger.action(
      "#{@name} recuperou #{value} HP. HP: #{@hp}/#{@max_hp}"
    )

  end

  def hp_rate

    return 0.0 if @max_hp <= 0

    return @hp.to_f / @max_hp.to_f

  end

  def check_death

    return if @hp > 0

    die

  end

  def die

    return unless @alive

    @alive = false

    @respawn_counter = @respawn_time

    clear_target_if_needed

    hide_event

    FO_Logger.action(
      "#{@name} morreu."
    )

  end

  def clear_target_if_needed

    return unless defined?(FO_TargetSystem)

    current_target = FO_TargetSystem.current_target

    if current_target == @event

      FO_TargetSystem.clear_target

      FO_Logger.action(
        "Target limpo porque #{@name} morreu."
      )

    end

  end

  def hide_event

    @event.transparent = true if @event.respond_to?(:transparent=)

    @event.instance_variable_set(:@through, true)

  end

  def show_event

    @event.transparent = false if @event.respond_to?(:transparent=)

    @event.instance_variable_set(:@through, false)

  end

  def update

    update_respawn

  end

  def update_respawn

    return if @alive

    @respawn_counter -= 1

    if @respawn_counter <= 0

      respawn

    end

  end

  def respawn

    move_to_random_position if FO_EntityRuntimeConfig::RANDOM_RESPAWN

    @alive = true

    @hp = @max_hp

    show_event

    FO_Logger.action(
      "#{@name} renasceu em #{@event.x}, #{@event.y}."
    )

  end

  def move_to_random_position

    position = random_respawn_position

    return if position.nil?

    @event.moveto(
      position[0],
      position[1]
    )

  end

  def random_respawn_position

    attempts = FO_EntityRuntimeConfig::RANDOM_RESPAWN_ATTEMPTS

    margin = FO_EntityRuntimeConfig::RESPAWN_MAP_MARGIN

    attempts.times do

      x = margin + rand($game_map.width - margin * 2)

      y = margin + rand($game_map.height - margin * 2)

      if valid_respawn_position?(x, y)

        return [x, y]

      end

    end

    return nil

  end

  def valid_respawn_position?(x, y)

    return false if x < 0

    return false if y < 0

    return false if x >= $game_map.width

    return false if y >= $game_map.height

    return false unless tile_passable?(x, y)

    return false if occupied_by_player?(x, y)

    return false if occupied_by_event?(x, y)

    return true

  end

  def tile_passable?(x, y)

    directions = [2, 4, 6, 8]

    for direction in directions

      return true if $game_map.passable?(x, y, direction, @event)

    end

    return false

  end

  def occupied_by_player?(x, y)

    return false if $game_player.nil?

    return $game_player.x == x && $game_player.y == y

  end

  def occupied_by_event?(x, y)

    for event_id in $game_map.events.keys

      event = $game_map.events[event_id]

      next if event.nil?

      next if event == @event

      next if event.instance_variable_get(:@through)

      if event.x == x && event.y == y

        return true

      end

    end

    return false

  end

end

module FO_EntityRuntimeManager

  @runtimes = []

  @initialized = false

  @map_id = nil

  def self.runtimes

    return @runtimes

  end

  def self.setup

    return if $game_map.nil?

    return if FO_MapEntitySystem.map_entities.empty?

    dispose

    for entity_data in FO_MapEntitySystem.map_entities

      runtime = FO_EntityRuntime.new(
        entity_data
      )

      @runtimes.push(runtime)

    end

    @initialized = true

    @map_id = $game_map.map_id

    FO_Logger.action(
      "Runtimes inicializados."
    )

  end

  def self.update

    return if $game_map.nil?

    if @map_id != $game_map.map_id

      @initialized = false

    end

    unless @initialized

      setup

    end

    for runtime in @runtimes

      runtime.update

    end

  end

  def self.find_by_event(event)

    for runtime in @runtimes

      return runtime if runtime.event == event

    end

    return nil

  end

  def self.find_by_name(name)

    for runtime in @runtimes

      if runtime.name.downcase == name.downcase

        return runtime

      end

    end

    return nil

  end

  def self.hit(name, value)

    runtime = find_by_name(name)

    return false if runtime.nil?

    runtime.damage(value)

    return true

  end

  def self.heal(name, value)

    runtime = find_by_name(name)

    return false if runtime.nil?

    runtime.heal(value)

    return true

  end

  def self.dispose

    @runtimes.clear

    @initialized = false

  end

end

class Scene_Map

  alias fo_entity_runtime_update update

  def update

    FO_EntityRuntimeManager.update

    fo_entity_runtime_update

  end

end

FO_Logger.action(
  "FO_EntityRuntimeSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "runtime",
  "FO_EntityRuntimeSystem carregado."
)

FO_CORE.debug(
  "FO_EntityRuntimeSystem carregado com sucesso."
)