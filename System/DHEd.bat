@echo OFF
cd "%~dp0"
python ..\tools\make\make.py -mod DarkestHourDev ..

if %ERRORLEVEL% GEQ 1 (
    pause
    exit /b %ERRORLEVEL%
)

echo Launching DHEd...
start ROEdLAA.exe %* -mod=DarkestHourDev -nogamma
