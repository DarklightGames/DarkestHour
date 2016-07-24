@echo OFF
cd "%~dp0"
..\tools\make\make.py -mod DarkestHourDev ..
echo Launching DHEd...
start ROEd.exe -mod=DarkestHourDev -nogamma