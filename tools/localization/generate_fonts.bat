@echo off
pushd %~dp0
virtualenv venv
.\venv\Scripts\activate.bat && pip3 install -r requirements.txt && python .\localization.py generate_font_scripts --mod DarkestHourDev && pause
popd
@echo on
