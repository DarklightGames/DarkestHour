@echo off
pushd %~dp0
make.py "%RODIR%" -mod DarkestHourDev -dumpint
popd
echo 
pause