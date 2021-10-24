@echo OFF
cd "%~dp0"
echo 1280 > ..\System\steam_appid.txt
call ..\tools\make\venv\Scripts\activate.bat && python ..\tools\make\make.py -mod DarkestHourDev ..

if %ERRORLEVEL% GEQ 1 (
    pause
    exit /b %ERRORLEVEL%
)

start RedOrchestraLargeAddressAware.exe %* -mod=DarkestHourDev -log=DHLog_%RANDOM%.log