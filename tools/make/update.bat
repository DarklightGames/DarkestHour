@echo off
pushd %~dp0
virtualenv venv
venv\Scripts\activate.bat & pip install -r requirements.txt
popd
pause