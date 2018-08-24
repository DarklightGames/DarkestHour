@echo OFF
cd "%~dp0"
python ..\tools\make\make.py -mod DarkestHourDev ..
echo Launching DHEd...
start ROEdLAA.exe -mod=DarkestHourDev -nogamma