@echo OFF
cd "%~dp0"
..\..\tools\make\make.py -mod DarkestHourDev ..\..
ucc server DH-Brecourt.rom?game=DH_Engine.DarkestHourGame?MaxPlayers=64? -log=ServerLog.log -mod=DarkestHourDev -ini=DarkestHourDev.ini