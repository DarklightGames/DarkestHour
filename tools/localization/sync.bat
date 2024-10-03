@echo off
pushd %~dp0
virtualenv venv
.\venv\Scripts\activate.bat && pip3 install -r requirements.txt && python .\localization.py sync --mod DarkestHourDev
popd
@echo on
