#==============================================================================
# ■ FO_EquipmentSystem
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.0
# Data......: 18/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de equipamentos do personagem.
#------------------------------------------------------------------------------
# Funções atuais:
# - Equipar armas
# - Equipar armaduras
# - Slots de equipamento
# - Recalcular stats
#------------------------------------------------------------------------------
#==============================================================================

class FO_PlayerData

  #===========================================================================
  # ■ ATTR_ACCESSOR
  #===========================================================================

  attr_accessor :equipped_weapon
  attr_accessor :equipped_armor

  #===========================================================================
  # ■ setup_equipment
  #--------------------------------------------------------------------------
  # Inicializa equipamentos.
  #===========================================================================
  def setup_equipment

    @equipped_weapon = nil
    @equipped_armor  = nil

    FO_Logger.action("#{@name} equipamentos inicializados.")

    FO_Debug.debug_log("engine", "Equipamentos criados.")

  end

  #===========================================================================
  # ■ equip_weapon
  #--------------------------------------------------------------------------
  # Equipa arma.
  #===========================================================================
  def equip_weapon(weapon_id)

    if $data_weapons.nil?

      FO_Logger.error("$data_weapons está nil.")

      return false

    end

    weapon = $data_weapons[weapon_id]

    if weapon.nil?

      FO_Logger.error("Weapon ID #{weapon_id} não encontrada.")

      return false

    end

    @equipped_weapon = weapon

    FO_Logger.action(
      "#{@name} equipou arma #{weapon.name}"
    )

    FO_Debug.debug_log("engine", "Weapon equipada.")

    recalculate_stats

    return true

  end

  #===========================================================================
  # ■ equip_armor
  #--------------------------------------------------------------------------
  # Equipa armadura.
  #===========================================================================
  def equip_armor(armor_id)

    if $data_armors.nil?

      FO_Logger.error("$data_armors está nil.")

      return false

    end

    armor = $data_armors[armor_id]

    if armor.nil?

      FO_Logger.error("Armor ID #{armor_id} não encontrada.")

      return false

    end

    @equipped_armor = armor

    FO_Logger.action(
      "#{@name} equipou armadura #{armor.name}"
    )

    FO_Debug.debug_log("engine", "Armor equipada.")

    recalculate_stats

    return true

  end

  #===========================================================================
  # ■ unequip_weapon
  #--------------------------------------------------------------------------
  # Remove arma equipada.
  #===========================================================================
  def unequip_weapon

    return if @equipped_weapon.nil?

    FO_Logger.action(
      "#{@name} desequipou #{@equipped_weapon.name}"
    )

    @equipped_weapon = nil

    recalculate_stats

  end

  #===========================================================================
  # ■ unequip_armor
  #--------------------------------------------------------------------------
  # Remove armadura equipada.
  #===========================================================================
  def unequip_armor

    return if @equipped_armor.nil?

    FO_Logger.action(
      "#{@name} desequipou #{@equipped_armor.name}"
    )

    @equipped_armor = nil

    recalculate_stats

  end

  #===========================================================================
  # ■ weapon_attack_bonus
  #--------------------------------------------------------------------------
  # Retorna bônus da arma.
  #===========================================================================
  def weapon_attack_bonus

    return 0 if @equipped_weapon.nil?

    return @equipped_weapon.atk

  end

  #===========================================================================
  # ■ armor_defense_bonus
  #--------------------------------------------------------------------------
  # Retorna bônus da armadura.
  #===========================================================================
  def armor_defense_bonus

    return 0 if @equipped_armor.nil?

    return @equipped_armor.pdef

  end

end

#==============================================================================
# ■ Expansão de fórmulas
#==============================================================================

class FO_PlayerData

  alias fo_equipment_attack_power attack_power
  alias fo_equipment_defense defense

  #===========================================================================
  # ■ attack_power
  #===========================================================================
  def attack_power

    base_attack = fo_equipment_attack_power

    return base_attack + weapon_attack_bonus

  end

  #===========================================================================
  # ■ defense
  #===========================================================================
  def defense

    base_defense = fo_equipment_defense

    return base_defense + armor_defense_bonus

  end

end

#==============================================================================
# ■ Expansão do initialize
#==============================================================================

class FO_PlayerData

  alias fo_equipment_initialize initialize

  #===========================================================================
  # ■ initialize
  #===========================================================================
  def initialize(name = "Player")

    fo_equipment_initialize(name)

    setup_equipment

    FO_Logger.action("#{@name} equipamentos carregados.")

  end

end

#==============================================================================
# ■ Inicialização
#==============================================================================

FO_Logger.action("FO_EquipmentSystem carregado com sucesso.")

FO_Debug.debug_log("engine", "FO_EquipmentSystem carregado.")

FO_CORE.debug("FO_EquipmentSystem carregado com sucesso.")