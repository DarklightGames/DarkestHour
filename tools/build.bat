@echo off
REM This is run in the automation system to perform a full rebuild and localization synchronization.
pushd %~dp0
.\make\clean.bat && .\localization\sync.bat
popd
@echo ON
