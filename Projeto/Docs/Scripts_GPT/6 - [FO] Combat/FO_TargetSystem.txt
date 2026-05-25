#==============================================================================
# ■ FO_TargetSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.2.0
# Data......: 20/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de target do projeto Fields Online.
#==============================================================================

module FO_TargetSystem

  DEFAULT_ATTACK_RANGE = 1

  def self.setup

    $fo_target = nil

  end

  def self.current_target

    return $fo_target

  end

  def self.clear_target

    $fo_target = nil

    FO_Logger.action("Target limpo.")

  end

  def self.set_target(event = nil)

    return false if event.nil?

    runtime = FO_EntityRuntimeManager.find_by_event(event)

    return false if runtime.nil?

    return false if runtime.dead?

    $fo_target = event

    FO_Logger.action("Target selecionado: #{runtime.name}")

    return true

  end

  def self.set_target_by_name(name = nil)

    return false if name.nil?

    runtime = FO_EntityRuntimeManager.find_by_name(name)

    return false if runtime.nil?

    return false if runtime.dead?

    $fo_target = runtime.event

    FO_Logger.action("Target selecionado: #{runtime.name}")

    return true

  end

  def self.target(name = nil)

    return set_target_by_name(name)

  end

  def self.distance(entity_a, entity_b)

    dx = (entity_a.x - entity_b.x).abs

    dy = (entity_a.y - entity_b.y).abs

    return dx + dy

  end

  def self.in_range?(entity_a, entity_b, range = DEFAULT_ATTACK_RANGE)

    return distance(entity_a, entity_b) <= range

  end

  def self.valid_target?(target)

    return false if target.nil?

    runtime = FO_EntityRuntimeManager.find_by_event(target)

    return false if runtime.nil?

    return false if runtime.dead?

    return true

  end

  def self.current_target_valid?

    return valid_target?($fo_target)

  end

  def self.nearest_target(entity, targets)

    nearest = nil

    nearest_distance = 999999

    for target in targets

      next unless valid_target?(target)

      current_distance = distance(entity, target)

      if current_distance < nearest_distance

        nearest = target

        nearest_distance = current_distance

      end

    end

    return nearest

  end

  def self.select_nearest_runtime_target

    return false if $game_player.nil?

    targets = []

    for runtime in FO_EntityRuntimeManager.runtimes

      next if runtime.nil?

      next if runtime.dead?

      next unless runtime.entity_type == :mob || runtime.entity_type == :boss

      targets.push(runtime.event)

    end

    nearest = nearest_target($game_player, targets)

    return false if nearest.nil?

    return set_target(nearest)

  end

end

FO_TargetSystem.setup

FO_Logger.action("FO_TargetSystem carregado com sucesso.")

FO_Debug.debug_log(
  "combat",
  "FO_TargetSystem carregado."
)

FO_CORE.debug(
  "FO_TargetSystem carregado com sucesso."
)