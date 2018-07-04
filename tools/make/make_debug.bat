@echo off
pushd %~dp0
make.py ../../. -mod DarkestHourDev -dumpint -debug
popd
pause