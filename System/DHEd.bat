@echo OFF
cd "%~dp0"
call python ..\tools\make\make.py -mod DarkestHourDev ..

if %ERRORLEVEL% GEQ 1 (
    pause
    exit /b %ERRORLEVEL%
)

echo Resetting window positions...
call python ..\tools\scripts\clear-windowpositions.py ..\DarkestHourDev\System\DarkestHourDevUser.ini

xcopy /y .\EditorSelectionFix\D3DDrv.dll .\D3DDrv.dll

echo Launching DHEd...
start ROEdLAA.exe %* -mod=DarkestHourDev -nogamma
