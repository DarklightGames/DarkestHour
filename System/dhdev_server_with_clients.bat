@echo OFF
cd "%~dp0"
echo 1280 > ..\System\steam_appid.txt
python ..\tools\make\make.py -mod DarkestHourDev ..

if %ERRORLEVEL% GEQ 1 (
    pause
    exit /b %ERRORLEVEL%
)

python ..\tools\test_multiplayer.py DarkestHourDev DH-Makhnovo_Advance.rom?game=DH_Engine.DarkestHourGame?MaxPlayers=64?Mutator=DH_AdminMenuMutator.DHAdminMenuMutator