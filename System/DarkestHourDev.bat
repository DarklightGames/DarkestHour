@echo OFF
cd "%~dp0"
echo 1280 > ..\System\steam_appid.txt
python ..\tools\make\make.py -mod DarkestHourDev ..
start RedOrchestraLargeAddressAware.exe -mod=DarkestHourDev