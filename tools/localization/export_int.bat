@echo off
pushd %~dp0
virtualenv venv
.\venv\Scripts\activate.bat && pip3 install -r requirements.txt && python .\localization.py export_directory -o ../../submodules/weblate-darklightgames ../../DarkestHourDev/System -l en
popd
@echo on
