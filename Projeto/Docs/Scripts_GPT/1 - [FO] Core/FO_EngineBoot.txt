#==============================================================================
# ■ FO_EngineBoot
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.4.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema responsável pela inicialização oficial da engine.
#==============================================================================

module FO_EngineBoot

  ENGINE_VERSION = "1.4.0"

  SYSTEMS = [

    "FO_Core",
    "FO_Settings",
    "FO_Logger",
    "FO_Debug",
    "FO_DeveloperMode",
    "FO_Utils",
    "FO_DataManager",

    "FO_DatabaseBridge",
    "FO_ItemDatabase",

    "FO_PlayerData",
    "FO_PlayerStats",
    "FO_PlayerLevelSystem",
    "FO_Inventory",
    "FO_EquipmentSystem",

    "FO_CombatSystem",
    "FO_TargetSystem",
    "FO_AutoAttackSystem",
    "FO_MobAISystem",
    "FO_LootSystem",
    "FO_EnemySystem",
    "FO_AISystem",

    "FO_MapEntitySystem",
    "FO_EntityVisualSystem",
    "FO_TargetVisualSystem",
    "FO_FloatingDamageSystem",
    "FO_InteractionSystem",

    "FO_EntityRuntimeSystem",
    "FO_PlayerRuntimeSystem",

    "FO_PlayerHUDSystem",
    "FO_PlayerEXPBarSystem",
    "FO_FloatingLootSystem"

  ]

  def self.start

    FO_Logger.action(
      "========================================"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "FIELDS ONLINE ENGINE BOOT"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Versão #{ENGINE_VERSION}"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Inicializando engine..."
    ) if defined?(FO_Logger)

    register_systems

    FO_Logger.action(
      "Engine iniciada com sucesso."
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "========================================"
    ) if defined?(FO_Logger)

    FO_Debug.debug_log(
      "engine",
      "Boot iniciado."
    ) if defined?(FO_Debug)

  end

  def self.register_systems

    for system_name in SYSTEMS

      if defined?(FO_Logger)

        FO_Logger.action(
          "Sistema registrado: #{system_name}"
        )

      end

    end

    FO_Debug.debug_log(
      "engine",
      "Sistemas registrados."
    ) if defined?(FO_Debug)

  end

end

FO_EngineBoot.start

FO_CORE.debug(
  "FO_EngineBoot carregado com sucesso."
) if defined?(FO_CORE)