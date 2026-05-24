#==============================================================================
# ■ FO_MapEntitySystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.2
# Data......: 18/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de entidades do mapa do projeto Fields Online.
#------------------------------------------------------------------------------
#==============================================================================

#==============================================================================
# ■ Expansão do Game_Event
#------------------------------------------------------------------------------
# Permite acesso ao RPG::Event interno.
#==============================================================================

class Game_Event

  attr_reader :event

end

#==============================================================================
# ■ FO_MapEntitySystem
#==============================================================================

module FO_MapEntitySystem

  #===========================================================================
  # ■ ATTR
  #===========================================================================

  @map_entities = []

  #===========================================================================
  # ■ map_entities
  #===========================================================================
  def self.map_entities

    return @map_entities

  end

  #===========================================================================
  # ■ clear_entities
  #===========================================================================
  def self.clear_entities

    @map_entities.clear

    FO_Debug.debug_log(
      "map",
      "Entidades limpas."
    )

  end

  #===========================================================================
  # ■ scan_map_entities
  #--------------------------------------------------------------------------
  # Escaneia eventos do mapa.
  #===========================================================================
  def self.scan_map_entities

    return if $game_map.nil?

    clear_entities

    for event_id in $game_map.events.keys

      event = $game_map.events[event_id]

      next if event.nil?

      parse_event(event)

    end

    FO_Logger.action(
      "Mapa escaneado: #{@map_entities.size} entidades encontradas."
    )

    FO_Debug.debug_log(
      "map",
      "Scan de entidades concluído."
    )

  end

  #===========================================================================
  # ■ parse_event
  #--------------------------------------------------------------------------
  # Identifica tipo da entidade.
  #===========================================================================
  def self.parse_event(event)

    return if event.nil?

    return if event.event.nil?

    event_name = event.event.name

    return if event_name.nil?

    return if event_name.empty?

    prefix = event_name[0,1]

    case prefix

    when "@"

      register_npc(event, event_name)

    when "$"

      register_mob(event, event_name)

    when "!"

      register_boss(event, event_name)

    when "?"

      register_quest(event, event_name)

    end

  end

  #===========================================================================
  # ■ register_npc
  #===========================================================================
  def self.register_npc(event, event_name)

    entity_data = {
      :type  => :npc,
      :name  => event_name,
      :event => event
    }

    @map_entities.push(entity_data)

    FO_Logger.action(
      "NPC registrado: #{event_name}"
    )

  end

  #===========================================================================
  # ■ register_mob
  #===========================================================================
  def self.register_mob(event, event_name)

    entity_data = {
      :type  => :mob,
      :name  => event_name,
      :event => event
    }

    @map_entities.push(entity_data)

    FO_Logger.action(
      "Mob registrado: #{event_name}"
    )

  end

  #===========================================================================
  # ■ register_boss
  #===========================================================================
  def self.register_boss(event, event_name)

    entity_data = {
      :type  => :boss,
      :name  => event_name,
      :event => event
    }

    @map_entities.push(entity_data)

    FO_Logger.action(
      "Boss registrado: #{event_name}"
    )

  end

  #===========================================================================
  # ■ register_quest
  #===========================================================================
  def self.register_quest(event, event_name)

    entity_data = {
      :type  => :quest,
      :name  => event_name,
      :event => event
    }

    @map_entities.push(entity_data)

    FO_Logger.action(
      "Quest registrada: #{event_name}"
    )

  end

end

#==============================================================================
# ■ Scene_Map
#------------------------------------------------------------------------------
# Escaneia entidades ao entrar no mapa.
#==============================================================================

class Scene_Map

  alias fo_map_entity_main main

  #===========================================================================
  # ■ main
  #===========================================================================
  def main

    FO_MapEntitySystem.scan_map_entities

    fo_map_entity_main

  end

end

#==============================================================================
# ■ Inicialização
#==============================================================================

FO_Logger.action("FO_MapEntitySystem carregado com sucesso.")

FO_Debug.debug_log(
  "map",
  "FO_MapEntitySystem carregado."
)

FO_CORE.debug(
  "FO_MapEntitySystem carregado com sucesso."
)