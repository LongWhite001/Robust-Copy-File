@echo off
setlocal enabledelayedexpansion

:: Função para escrever lentamente
set "msg=Robust Copy File:"
for /l %%i in (0,1,17) do (
    set "char=!msg:~%%i,1!"
    <nul set /p="!char!"
    ping localhost -n 1 >nul
)
echo.

:: Selecionar pasta de origem
echo Selecione a pasta de origem.
set "VBS1=%temp%\selectfolder1.vbs"
echo Set objDialog = CreateObject("Shell.Application") > "%VBS1%"
echo Set objFolder = objDialog.BrowseForFolder(0, "Selecione a pasta de origem:", 0, "") >> "%VBS1%"
echo If Not objFolder Is Nothing Then >> "%VBS1%"
echo    WScript.Echo objFolder.Items().Item().Path >> "%VBS1%"
echo End If >> "%VBS1%"
for /f "usebackq delims=" %%a in (`cscript //nologo "%VBS1%"`) do set "src=%%a"
del "%VBS1%"
if not defined src (
    echo Nenhuma pasta de origem selecionada. Saindo...
    exit /b
)

:: Selecionar pasta de destino
echo Selecione a pasta de destino.
set "VBS2=%temp%\selectfolder2.vbs"
echo Set objDialog = CreateObject("Shell.Application") > "%VBS2%"
echo Set objFolder = objDialog.BrowseForFolder(0, "Selecione a pasta de destino:", 0, "") >> "%VBS2%"
echo If Not objFolder Is Nothing Then >> "%VBS2%"
echo    WScript.Echo objFolder.Items().Item().Path >> "%VBS2%"
echo End If >> "%VBS2%"
for /f "usebackq delims=" %%a in (`cscript //nologo "%VBS2%"`) do set "dst=%%a"
del "%VBS2%"
if not defined dst (
    echo Nenhuma pasta de destino selecionada. Saindo...
    exit /b
)

:: Copiar arquivos
echo Copiando de "!src!" para "!dst!"...
robocopy "!src!" "!dst!" /E /COPYALL /R:3 /W:5
if %ERRORLEVEL% GEQ 8 (
    echo Erro ao copiar arquivos! Verifique os caminhos e permissoes.
) else (
    echo Copia concluida com sucesso!
)
pause