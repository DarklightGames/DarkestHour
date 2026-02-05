@echo off
REM This script clears up [WindowPositions] settings from User.ini files as
REM a workaround for the jumbled up interface bug that occurs in the editor.

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo "Error (1): Missing argument"
    exit /b 1
)

set "CONFIG_PATH=%~1"

if not exist "!CONFIG_PATH!" (
    echo "Error (2): No such file or directory"
    exit /b 1
)

REM Call the PowerShell script to process the file
powershell -ExecutionPolicy Bypass -File "%~dp0clear-windowpositions.ps1" -ConfigPath "!CONFIG_PATH!"

if errorlevel 1 (
    echo Error during processing
    exit /b 1
)

endlocal
