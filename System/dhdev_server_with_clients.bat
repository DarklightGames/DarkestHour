@echo OFF
cd "%~dp0"
echo 1280 > ..\System\steam_appid.txt
python ..\tools\make\make.py -mod DarkestHourDev ..

if %ERRORLEVEL% GEQ 1 (
    pause
    exit /b %ERRORLEVEL%
)

start ucc server DH-Target_Range.rom?game=DH_Engine.DarkestHourGame?MaxPlayers=64?Mutator=DH_AdminMenuMutator.DHAdminMenuMutator -log=DHServerLog_%RANDOM%.log -mod=DarkestHourDev -ini=DarkestHourDev.ini -multihome=127.0.0.1
start RedOrchestraLargeAddressAware.exe 127.0.0.1:7757 -mod=DarkestHourDev -log=DHLog_%RANDOM%.log
start RedOrchestraLargeAddressAware1.exe 127.0.0.1:7757 -mod=DarkestHourDev -log=DHLog_%RANDOM%.log
start RedOrchestraLargeAddressAware2.exe 127.0.0.1:7757 -mod=DarkestHourDev -log=DHLog_%RANDOM%.log
