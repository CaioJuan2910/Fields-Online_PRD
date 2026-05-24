@echo off
setlocal enabledelayedexpansion

set "PASTA=D:\Fields Online\Projeto\Docs\Scripts_GPT"

if not exist "%PASTA%" (
    echo Pasta nao encontrada:
    echo %PASTA%
    pause
    exit /b
)

echo ==========================================
echo Procurando arquivos .txt em todas as subpastas...
echo ==========================================
echo.

for /r "%PASTA%" %%F in (*.txt) do (

    set "ARQUIVO=%%~fF"
    set "NOVO=%%~dpnF.rb"

    ren "%%~fF" "%%~nF.rb"

    echo Convertido:
    echo %%~fF
    echo ^> %%~dpnF.rb
    echo.
)

echo ==========================================
echo Processo concluido.
echo ==========================================
pause