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

for /r "%PASTA%" %%F in (*.rb) do (

    set "ARQUIVO=%%~fF"
    set "NOVO=%%~dpnF.txt"

    ren "%%~fF" "%%~nF.txt"

    echo Convertido:
    echo %%~fF
    echo ^> %%~dpnF.txt
    echo.
)

echo ==========================================
echo Processo concluido.
echo ==========================================
pause