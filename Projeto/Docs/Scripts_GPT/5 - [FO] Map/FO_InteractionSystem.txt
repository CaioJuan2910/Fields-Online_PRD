#==============================================================================
# ■ FO_InteractionSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.1.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema central de interação com entidades do mapa.
#==============================================================================

module FO_InteractionSystem

  def self.i(event_id = nil)

    return interact_event(event_id)

  end

  def self.interact_event(event_id = nil)

    return false if $game_map.nil?

    event_id = current_event_id if event_id.nil?

    return false if event_id.nil?

    event = $game_map.events[event_id]

    return false if event.nil?

    return interact(event)

  end

  def self.current_event_id

    return nil if $game_system.nil?

    interpreter = $game_system.map_interpreter

    return nil if interpreter.nil?

    return interpreter.instance_variable_get(:@event_id)

  end

  def self.interact(event)

    return false if event.nil?

    entity_type = get_entity_type(event)

    case entity_type

    when :mob
      return interact_mob(event)

    when :boss
      return interact_boss(event)

    when :npc
      return interact_npc(event)

    when :quest
      return interact_quest(event)

    else

      FO_Logger.error(
        "Interação inválida: evento sem tipo reconhecido."
      )

      return false

    end

  end

  def self.get_entity_type(event)

    name = get_event_name(event)

    return nil if name.nil?
    return nil if name == ""

    prefix = name[0, 1]

    case prefix

    when "@"
      return :npc

    when "$"
      return :mob

    when "!"
      return :boss

    when "?"
      return :quest

    end

    return nil

  end

  def self.get_event_name(event)

    return nil if event.nil?

    return nil unless event.respond_to?(:event)

    return event.event.name

  end

  def self.interact_mob(event)

    return select_combat_target(event)

  end

  def self.interact_boss(event)

    return select_combat_target(event)

  end

  def self.select_combat_target(event)

    return false unless defined?(FO_TargetSystem)

    result = FO_TargetSystem.set_target(event)

    if result

      runtime = FO_EntityRuntimeManager.find_by_event(event)

      if runtime

        FO_Logger.action(
          "Interação selecionou target: #{runtime.name}"
        )

      end

    end

    return result

  end

  def self.interact_npc(event)

    FO_Logger.action(
      "Interação NPC detectada."
    )

    return true

  end

  def self.interact_quest(event)

    FO_Logger.action(
      "Interação Quest detectada."
    )

    return true

  end

end

FO_Logger.action(
  "FO_InteractionSystem carregado com sucesso."
)

FO_Debug.debug_log(
  "map",
  "FO_InteractionSystem carregado."
)

FO_CORE.debug(
  "FO_InteractionSystem carregado com sucesso."
)