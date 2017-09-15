@echo off
pushd %~dp0
make.py ../../. -mod DarkestHourDev -clean -dumpint
popd
pause