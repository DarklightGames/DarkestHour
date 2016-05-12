@echo off
pushd %~dp0
python make.py -mod DarkestHourDev -dumpint
popd
echo 
pause