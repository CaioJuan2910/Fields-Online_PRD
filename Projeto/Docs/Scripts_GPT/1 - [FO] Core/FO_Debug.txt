#==============================================================================
# ■ FO_Debug
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.1.0
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de debug técnico do projeto Fields Online.
#==============================================================================

module FO_Debug

  ENABLE_DEBUG_HUD = false

  DEBUG_FOLDER = "Debug"

  def self.create_debug_folder

    unless FileTest.exist?(DEBUG_FOLDER)
      Dir.mkdir(DEBUG_FOLDER)
    end

  end

  def self.current_date

    time = Time.now

    return sprintf(
      "%04d_%02d_%02d",
      time.year,
      time.month,
      time.day
    )

  end

  def self.current_time

    time = Time.now

    return sprintf(
      "%02d:%02d:%02d",
      time.hour,
      time.min,
      time.sec
    )

  end

  def self.debug_log(type, message)

    return if defined?(FO_Settings) &&
      FO_Settings::ENABLE_DEBUG == false

    begin

      create_debug_folder

      file_name = "fo_debug_#{type}_#{current_date}.txt"

      file_path = "#{DEBUG_FOLDER}/#{file_name}"

      file = File.open(file_path, "a")

      file.write("[#{current_time}] #{message}\n")

      file.close

    rescue => error

      if defined?(FO_Logger)
        FO_Logger.error("FO_Debug ERROR: #{error}")
      end

    end

  end

end

class FO_Debug_HUD

  def initialize

    @sprite = Sprite.new

    @sprite.bitmap = Bitmap.new(300, 120)

    @sprite.x = 5
    @sprite.y = 5
    @sprite.z = 9999

    refresh

  end

  def refresh

    @sprite.bitmap.clear

    return unless $game_player
    return unless $game_map

    text = ""

    text += "FIELDS ONLINE DEBUG\n"
    text += "FPS: #{Graphics.frame_rate}\n"
    text += "MAP ID: #{$game_map.map_id}\n"
    text += "PLAYER X: #{$game_player.x}\n"
    text += "PLAYER Y: #{$game_player.y}\n"

    @sprite.bitmap.font.size = 18

    @sprite.bitmap.draw_text(
      0,
      0,
      300,
      120,
      text
    )

  end

  def update

    refresh

  end

  def dispose

    @sprite.bitmap.dispose if @sprite && @sprite.bitmap

    @sprite.dispose if @sprite

  end

end

class Scene_Map

  alias fo_debug_main main
  alias fo_debug_update update

  def main

    if FO_Debug::ENABLE_DEBUG_HUD
      @fo_debug_hud = FO_Debug_HUD.new
    end

    FO_Debug.debug_log(
      "engine",
      "Scene_Map iniciada."
    )

    fo_debug_main

    if @fo_debug_hud
      @fo_debug_hud.dispose
      @fo_debug_hud = nil
    end

  end

  def update

    fo_debug_update

    if @fo_debug_hud
      @fo_debug_hud.update
    end

  end

end

FO_Debug.create_debug_folder

FO_Debug.debug_log(
  "engine",
  "FO_Debug carregado com sucesso."
)

FO_Logger.action(
  "FO_Debug carregado com sucesso."
) if defined?(FO_Logger)