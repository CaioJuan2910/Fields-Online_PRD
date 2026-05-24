#==============================================================================
# ■ FO_DatabaseBridge
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Ponte oficial entre o Database nativo do RMXP e os sistemas FO_*.
#------------------------------------------------------------------------------
# Funções atuais:
# - Acesso seguro aos dados do RMXP
# - Actors
# - Classes
# - Skills
# - Items
# - Weapons
# - Armors
# - Enemies
# - States
# - Animations
# - System
#==============================================================================

module FO_DatabaseBridge

  #===========================================================================
  # ■ ready?
  #===========================================================================
  def self.ready?

    return false if $data_actors.nil?
    return false if $data_classes.nil?
    return false if $data_skills.nil?
    return false if $data_items.nil?
    return false if $data_weapons.nil?
    return false if $data_armors.nil?
    return false if $data_enemies.nil?
    return false if $data_states.nil?
    return false if $data_animations.nil?
    return false if $data_system.nil?

    return true

  end

  #===========================================================================
  # ■ actor
  #===========================================================================
  def self.actor(id)

    return nil unless ready?

    return nil if id.nil?

    return $data_actors[id]

  end

  #===========================================================================
  # ■ actor_name
  #===========================================================================
  def self.actor_name(id)

    data = actor(id)

    return nil if data.nil?

    return data.name

  end

  #===========================================================================
  # ■ klass
  #===========================================================================
  def self.klass(id)

    return nil unless ready?

    return nil if id.nil?

    return $data_classes[id]

  end

  #===========================================================================
  # ■ class_name
  #===========================================================================
  def self.class_name(id)

    data = klass(id)

    return nil if data.nil?

    return data.name

  end

  #===========================================================================
  # ■ skill
  #===========================================================================
  def self.skill(id)

    return nil unless ready?

    return nil if id.nil?

    return $data_skills[id]

  end

  #===========================================================================
  # ■ skill_name
  #===========================================================================
  def self.skill_name(id)

    data = skill(id)

    return nil if data.nil?

    return data.name

  end

  #===========================================================================
  # ■ item
  #===========================================================================
  def self.item(id)

    return nil unless ready?

    return nil if id.nil?

    return $data_items[id]

  end

  #===========================================================================
  # ■ item_name
  #===========================================================================
  def self.item_name(id)

    data = item(id)

    return nil if data.nil?

    return data.name

  end

  #===========================================================================
  # ■ item_by_name
  #===========================================================================
  def self.item_by_name(name)

    return nil unless ready?

    return nil if name.nil?

    for item in $data_items

      next if item.nil?

      return item if item.name == name

    end

    return nil

  end

  #===========================================================================
  # ■ item_id_by_name
  #===========================================================================
  def self.item_id_by_name(name)

    data = item_by_name(name)

    return nil if data.nil?

    return data.id

  end

  #===========================================================================
  # ■ weapon
  #===========================================================================
  def self.weapon(id)

    return nil unless ready?

    return nil if id.nil?

    return $data_weapons[id]

  end

  #===========================================================================
  # ■ weapon_name
  #===========================================================================
  def self.weapon_name(id)

    data = weapon(id)

    return nil if data.nil?

    return data.name

  end

  #===========================================================================
  # ■ weapon_by_name
  #===========================================================================
  def self.weapon_by_name(name)

    return nil unless ready?

    return nil if name.nil?

    for weapon in $data_weapons

      next if weapon.nil?

      return weapon if weapon.name == name

    end

    return nil

  end

  #===========================================================================
  # ■ armor
  #===========================================================================
  def self.armor(id)

    return nil unless ready?

    return nil if id.nil?

    return $data_armors[id]

  end

  #===========================================================================
  # ■ armor_name
  #===========================================================================
  def self.armor_name(id)

    data = armor(id)

    return nil if data.nil?

    return data.name

  end

  #===========================================================================
  # ■ armor_by_name
  #===========================================================================
  def self.armor_by_name(name)

    return nil unless ready?

    return nil if name.nil?

    for armor in $data_armors

      next if armor.nil?

      return armor if armor.name == name

    end

    return nil

  end

  #===========================================================================
  # ■ enemy
  #===========================================================================
  def self.enemy(id)

    return nil unless ready?

    return nil if id.nil?

    return $data_enemies[id]

  end

  #===========================================================================
  # ■ enemy_name
  #===========================================================================
  def self.enemy_name(id)

    data = enemy(id)

    return nil if data.nil?

    return data.name

  end

  #===========================================================================
  # ■ enemy_by_name
  #===========================================================================
  def self.enemy_by_name(name)

    return nil unless ready?

    return nil if name.nil?

    for enemy in $data_enemies

      next if enemy.nil?

      return enemy if enemy.name == name

    end

    return nil

  end

  #===========================================================================
  # ■ enemy_id_by_name
  #===========================================================================
  def self.enemy_id_by_name(name)

    data = enemy_by_name(name)

    return nil if data.nil?

    return data.id

  end

  #===========================================================================
  # ■ state
  #===========================================================================
  def self.state(id)

    return nil unless ready?

    return nil if id.nil?

    return $data_states[id]

  end

  #===========================================================================
  # ■ animation
  #===========================================================================
  def self.animation(id)

    return nil unless ready?

    return nil if id.nil?

    return $data_animations[id]

  end

  #===========================================================================
  # ■ system
  #===========================================================================
  def self.system

    return nil unless ready?

    return $data_system

  end

  #===========================================================================
  # ■ item_price
  #===========================================================================
  def self.item_price(id)

    data = item(id)

    return 0 if data.nil?

    return data.price

  end

  #===========================================================================
  # ■ weapon_price
  #===========================================================================
  def self.weapon_price(id)

    data = weapon(id)

    return 0 if data.nil?

    return data.price

  end

  #===========================================================================
  # ■ armor_price
  #===========================================================================
  def self.armor_price(id)

    data = armor(id)

    return 0 if data.nil?

    return data.price

  end

  #===========================================================================
  # ■ item_description
  #===========================================================================
  def self.item_description(id)

    data = item(id)

    return "" if data.nil?

    return data.description

  end

  #===========================================================================
  # ■ weapon_description
  #===========================================================================
  def self.weapon_description(id)

    data = weapon(id)

    return "" if data.nil?

    return data.description

  end

  #===========================================================================
  # ■ armor_description
  #===========================================================================
  def self.armor_description(id)

    data = armor(id)

    return "" if data.nil?

    return data.description

  end

  #===========================================================================
  # ■ debug_print_summary
  #===========================================================================
  def self.debug_print_summary

    unless ready?

      FO_Logger.error(
        "FO_DatabaseBridge: Database RMXP ainda não está pronto."
      ) if defined?(FO_Logger)

      return false

    end

    FO_Logger.action(
      "===== FO DATABASE BRIDGE ====="
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Actors: #{$data_actors.size - 1}"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Classes: #{$data_classes.size - 1}"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Skills: #{$data_skills.size - 1}"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Items: #{$data_items.size - 1}"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Weapons: #{$data_weapons.size - 1}"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Armors: #{$data_armors.size - 1}"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Enemies: #{$data_enemies.size - 1}"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "States: #{$data_states.size - 1}"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Animations: #{$data_animations.size - 1}"
    ) if defined?(FO_Logger)

    FO_Logger.action(
      "Database RMXP conectado com sucesso."
    ) if defined?(FO_Logger)

    return true

  end

  #===========================================================================
  # ■ test
  #===========================================================================
  def self.test

    return debug_print_summary

  end

end

FO_Logger.action(
  "FO_DatabaseBridge carregado com sucesso."
) if defined?(FO_Logger)

FO_Debug.debug_log(
  "database",
  "FO_DatabaseBridge carregado."
) if defined?(FO_Debug)

FO_CORE.debug(
  "FO_DatabaseBridge carregado com sucesso."
) if defined?(FO_CORE)