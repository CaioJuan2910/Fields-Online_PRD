#==============================================================================
# ■ FO_DataManager
#------------------------------------------------------------------------------
# Fields Online MMORPG
#------------------------------------------------------------------------------
# Autor.....: ChatGPT & Caio
# Versão....: 1.0.1
# Data......: 23/05/2026
#------------------------------------------------------------------------------
# Descrição:
# Sistema de gerenciamento de dados do projeto Fields Online.
#==============================================================================

module FO_DataManager

  DATA_FOLDER = "FO_Data"

  def self.create_data_folder

    unless FileTest.exist?(DATA_FOLDER)
      Dir.mkdir(DATA_FOLDER)
    end

  end

  def self.save_data(file_name, data)

    begin

      create_data_folder

      file_path = "#{DATA_FOLDER}/#{file_name}"

      file = File.open(file_path, "wb")

      Marshal.dump(data, file)

      file.close

      FO_Logger.action(
        "Arquivo salvo: #{file_name}"
      ) if defined?(FO_Logger)

      FO_Debug.debug_log(
        "engine",
        "Save executado: #{file_name}"
      ) if defined?(FO_Debug)

      return true

    rescue => error

      FO_Logger.error(
        "Erro ao salvar #{file_name}: #{error}"
      ) if defined?(FO_Logger)

      return false

    end

  end

  def self.load_data(file_name)

    begin

      file_path = "#{DATA_FOLDER}/#{file_name}"

      unless FileTest.exist?(file_path)

        FO_Logger.error(
          "Arquivo não encontrado: #{file_name}"
        ) if defined?(FO_Logger)

        return nil

      end

      file = File.open(file_path, "rb")

      data = Marshal.load(file)

      file.close

      FO_Logger.action(
        "Arquivo carregado: #{file_name}"
      ) if defined?(FO_Logger)

      return data

    rescue => error

      FO_Logger.error(
        "Erro ao carregar #{file_name}: #{error}"
      ) if defined?(FO_Logger)

      return nil

    end

  end

  def self.file_exists?(file_name)

    file_path = "#{DATA_FOLDER}/#{file_name}"

    return FileTest.exist?(file_path)

  end

  def self.delete_data(file_name)

    begin

      file_path = "#{DATA_FOLDER}/#{file_name}"

      return false unless FileTest.exist?(file_path)

      File.delete(file_path)

      FO_Logger.action(
        "Arquivo deletado: #{file_name}"
      ) if defined?(FO_Logger)

      return true

    rescue => error

      FO_Logger.error(
        "Erro ao deletar #{file_name}: #{error}"
      ) if defined?(FO_Logger)

      return false

    end

  end

end

FO_DataManager.create_data_folder

FO_Logger.action(
  "FO_DataManager carregado com sucesso."
) if defined?(FO_Logger)

FO_Debug.debug_log(
  "engine",
  "FO_DataManager carregado."
) if defined?(FO_Debug)