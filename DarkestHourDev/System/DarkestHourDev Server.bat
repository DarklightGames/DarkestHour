@echo OFF
cd "%~dp0"
..\..\tools\make\make.py -mod DarkestHourDev ..\..
ucc server DH-Brecourt.rom?game=DH_Engine.DarkestHourGame?MaxPlayers=64? -log=DHServerLog_%RANDOM%.log -mod=DarkestHourDev -ini=DarkestHourDev.ini