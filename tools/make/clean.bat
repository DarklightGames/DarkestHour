@echo off
pushd %~dp0
python make.py ../../. -mod DarkestHourDev -clean -dumpint -localize
popd
