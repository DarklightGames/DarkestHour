@echo off
pushd %~dp0
call venv\Scripts\activate && python make.py ../../. -mod DarkestHourDev -clean -dumpint && call venv\Scripts\deactivate
popd
pause