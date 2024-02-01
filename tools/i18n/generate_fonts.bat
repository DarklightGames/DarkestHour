virtualenv venv
.\venv\Scripts\activate.bat && pip3 install -r requirements.txt && python .\i18n.py generate_font_scripts --mod DarkestHourDev && pause
