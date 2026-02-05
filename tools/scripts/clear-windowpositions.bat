@echo off
REM This script clears up [WindowPositions] settings from User.ini files as
REM a workaround for the jumbled up interface bug that occurs in the editor.

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Error (1): Missing argument
    exit /b 1
)

set "CONFIG_PATH=%~1"

if not exist "!CONFIG_PATH!" (
    echo Error (2): No such file or directory
    exit /b 1
)

REM Create a temporary file to hold the output
set "TEMP_FILE=!CONFIG_PATH!.tmp"

REM Use PowerShell to process the file
powershell -Command "& {
    $content = Get-Content -Path '!CONFIG_PATH!' -Raw
    $content = [regex]::Replace($content, '\[WindowPositions\](\r?\n.*?)*?\r?\n(?=(\[|$))', '', [System.Text.RegularExpressions.RegexOptions]::Multiline)
    Set-Content -Path '!TEMP_FILE!' -Value $content -NoNewline
    Move-Item -Path '!TEMP_FILE!' -Destination '!CONFIG_PATH!' -Force
}"

if errorlevel 1 (
    echo Error during processing
    exit /b 1
)

endlocal
