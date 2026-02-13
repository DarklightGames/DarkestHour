@echo OFF
goto :begin

:help
echo Launch Red Orchestra SDK with optional build step for specified mod.
echo.
echo Usage: %~n0 [OPTION...]
echo.
echo Options:
echo   -build             - build the mod before launching editor
echo   -mod MOD_NAME      - specify the mod to launch (default: DarkestHourDev)
echo   -help              - show this help message
echo.
goto :eof

:begin
cd "%~dp0"

set "MOD_NAME=DarkestHourDev"
set "BUILD=0"

:parse_args
if "%~1"=="" goto done_parsing
if /I "%~1"=="-help" goto help
if /I "%~1"=="-build" set "BUILD=1" & shift & goto parse_args
if /I "%~1"=="-mod" set "MOD_NAME=%~2" & shift & shift & goto parse_args
shift
goto parse_args

:done_parsing

echo Mod: %MOD_NAME%
if "%BUILD%"=="1" (
    echo Building...
    call python ..\tools\make\make.py -mod %MOD_NAME% ..
    if %ERRORLEVEL% GEQ 1 (
        pause
        exit /b %ERRORLEVEL%
    )
)

echo Resetting window positions...
call ..\tools\scripts\clear-windowpositions.bat ..\%MOD_NAME%\System\%MOD_NAME%User.ini

echo Applying editor selection fix...
xcopy /y .\EditorSelectionFix\D3DDrv.dll .\D3DDrv.dll

echo Launching editor...
start ROEdLAA.exe -mod=%MOD_NAME% -nogamma
