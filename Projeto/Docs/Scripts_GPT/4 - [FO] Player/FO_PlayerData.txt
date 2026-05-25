#==============================================================================
# ■ FO_PlayerData
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.1
# Data......: 18/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Estrutura principal do personagem do jogador.
#------------------------------------------------------------------------------
#==============================================================================

class FO_PlayerData

  #===========================================================================
  # ■ ATTR_ACCESSOR
  #===========================================================================

  attr_accessor :name

  attr_accessor :level
  attr_accessor :exp
  attr_accessor :gold

  attr_accessor :hp
  attr_accessor :max_hp

  attr_accessor :mp
  attr_accessor :max_mp

  attr_accessor :map_id

  attr_accessor :x
  attr_accessor :y

  attr_accessor :inventory

  #===========================================================================
  # ■ initialize
  #===========================================================================
  def initialize(name = "Player")

    @name = name

    @level = 1

    @exp = 0

    @gold = 0

    @max_hp = 100
    @hp     = @max_hp

    @max_mp = 50
    @mp     = @max_mp

    @map_id = 1

    @x = 10
    @y = 10

    @inventory = []

    FO_Logger.action(
      "Personagem criado: #{@name}"
    )

    FO_Debug.debug_log(
      "engine",
      "FO_PlayerData criado."
    )

  end

  #===========================================================================
  # ■ alive?
  #--------------------------------------------------------------------------
  # Verifica se jogador está vivo.
  #===========================================================================
  def alive?

    return @hp > 0

  end

  #===========================================================================
  # ■ dead?
  #--------------------------------------------------------------------------
  # Verifica se jogador morreu.
  #===========================================================================
  def dead?

    return @hp <= 0

  end

  #===========================================================================
  # ■ gain_exp
  #--------------------------------------------------------------------------
  # Adiciona experiência.
  #===========================================================================
  def gain_exp(value)

    @exp += value

    FO_Logger.action(
      "#{@name} ganhou #{value} EXP."
    )

    check_level_up

  end

  #===========================================================================
  # ■ check_level_up
  #--------------------------------------------------------------------------
  # Verifica level up.
  #===========================================================================
  def check_level_up

    required_exp = @level * 100

    if @exp >= required_exp

      @exp -= required_exp

      @level += 1

      @max_hp += 10

      @max_mp += 5

      @hp = @max_hp

      @mp = @max_mp

      FO_Logger.action(
        "#{@name} subiu para o nível #{@level}"
      )

      FO_Debug.debug_log(
        "engine",
        "Level Up executado."
      )

    end

  end

  #===========================================================================
  # ■ gain_gold
  #--------------------------------------------------------------------------
  # Adiciona gold.
  #===========================================================================
  def gain_gold(value)

    @gold += value

    @gold = FO_Utils.clamp(
      @gold,
      0,
      FO_Settings::MAX_GOLD
    )

    FO_Logger.action(
      "#{@name} ganhou #{value} gold."
    )

  end

  #===========================================================================
  # ■ move_to
  #--------------------------------------------------------------------------
  # Move personagem.
  #===========================================================================
  def move_to(map_id, x, y)

    @map_id = map_id

    @x = x

    @y = y

    FO_Logger.action(
      "#{@name} moveu para mapa #{map_id} (#{x}, #{y})"
    )

  end

  #===========================================================================
  # ■ save
  #--------------------------------------------------------------------------
  # Salva personagem.
  #===========================================================================
  def save

    file_name = "#{@name.downcase}.rxdata"

    result = FO_DataManager.save_data(
      file_name,
      self
    )

    if result

      FO_Logger.action(
        "Personagem salvo: #{@name}"
      )

    else

      FO_Logger.error(
        "Falha ao salvar personagem."
      )

    end

  end

  #===========================================================================
  # ■ self.load
  #--------------------------------------------------------------------------
  # Carrega personagem.
  #===========================================================================
  def self.load(name)

    file_name = "#{name.downcase}.rxdata"

    player = FO_DataManager.load_data(file_name)

    if player

      FO_Logger.action(
        "Personagem carregado: #{name}"
      )

      return player

    else

      FO_Logger.error(
        "Falha ao carregar personagem."
      )

      return nil

    end

  end

end

#==============================================================================
# ■ Inicialização
#==============================================================================

FO_Logger.action(
  "FO_PlayerData carregado com sucesso."
)

FO_Debug.debug_log(
  "engine",
  "FO_PlayerData carregado."
)

FO_CORE.debug(
  "FO_PlayerData carregado com sucesso."
)