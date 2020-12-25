@echo OFF
cd "%~dp0"
python ..\tools\make\make.py -mod DarkestHourDev ..

if %ERRORLEVEL% GEQ 1 (
    pause
    exit /b %ERRORLEVEL%
)

echo Resetting window positions...
python ..\tools\scripts\clear-windowpositions.py ..\DarkestHourDev\System\DarkestHourDevUser.ini

echo Launching DHEd...
start ROEdLAA.exe %* -mod=DarkestHourDev -nogamma
