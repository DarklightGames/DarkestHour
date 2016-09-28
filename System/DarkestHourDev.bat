@echo OFF
cd "%~dp0"
echo 1280 > ..\System\steam_appid.txt
..\tools\make\make.py -mod DarkestHourDev ..
start RedOrchestraLargeAddressAware.exe -mod=DarkestHourDev