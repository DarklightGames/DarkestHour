@echo OFF
cd "%~dp0"
echo 1280 > ..\System\steam_appid.txt
python ..\tools\make\make.py -mod DarkestHourDev ..
start RedOrchestraLargeAddressAware.exe -mod=DarkestHourDev -log=DHLog_%RANDOM%.log 
start RedOrchestraLargeAddressAware1.exe -mod=DarkestHourDev -log=DHLog_%RANDOM%.log
start RedOrchestraLargeAddressAware2.exe -mod=DarkestHourDev -log=DHLog_%RANDOM%.log

ucc server DH-Target_Range.rom?game=DH_Engine.DarkestHourGame?MaxPlayers=64?Mutator=DH_AdminMenuMutator.DHAdminMenuMutator -log=DHServerLog_%RANDOM%.log -mod=DarkestHourDev -ini=DarkestHourDev.ini