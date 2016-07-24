@echo OFF
cd "%~dp0"
..\tools\make\make.py -mod DarkestHourDev ..
echo Launching DarkestHourDev...
start RedOrchestraLargeAddressAware.exe -mod=DarkestHourDev