@echo OFF
cd "%~dp0"
..\tools\make\make.py -mod DarkestHourDev ..
echo Launching DHEd...
start ROEdLAA.exe -mod=DarkestHourDev -nogamma