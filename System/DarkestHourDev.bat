@echo OFF
cd "%~dp0"
echo 1280 > ..\System\steam_appid.txt
..\tools\make\uccp.exe -q -i --directory .. DarkestHourDev

if %ERRORLEVEL% GEQ 1 (
    pause
    exit /b %ERRORLEVEL%
)

start RedOrchestraLargeAddressAware.exe %* -mod=DarkestHourDev -log=DHLog_%RANDOM%.log