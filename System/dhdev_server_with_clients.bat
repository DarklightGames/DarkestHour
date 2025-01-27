@echo OFF
goto :begin

:help
echo Launch DH server with optional clients
echo.
echo Usage: %~n0 [OPTION...] [OTHER...]
echo.
echo Options:
echo   --map MAP          - a MAP to launch the server on (defalt: DH-Target_Range)
echo   --clean            - compile all packages
echo   --dumpint          - dump localization files
echo   --safe             - don't kill UCC process when it's compiling
echo   --yes              - answer 'yes' to all prompts
echo   --no-kill          - don't kill UCC process
echo   --no-build         - skip the build step
echo   --no-run           - don't launch server and clients
echo   --no-pause         - exit immediately without waiting for input
echo.
echo Other arguments are passed to 'test_multiplayer.py', including:
echo   --clients NUM      - launch NUM clients skipping the prompt
echo   --pktlag PKTLAG    - simulate ping
echo   --pktloss PKTLOSS  - simulate packet loss
echo.
goto :eof

:begin
set ucc_task=UCC.exe
set help=0
set always_yes=0
set no_kill=0
set no_build=0
set no_run=0
set no_pause=0
set safe=0
set lock_file=StdOut.log
set map=DH-Target_Range
set map_dir=%~dp0..\DarkestHourDev\Maps
set arg_tail=
set make_args=

:parse_args_loop
rem Flag arguments
set arg_size=1

if "%1"=="--help" set "help=1" & goto :next_arg
if "%1"=="--yes" set "always_yes=1" & goto :next_arg
if "%1"=="--no-kill" set "no_kill=1" & goto :next_arg
if "%1"=="--no-build" set "no_build=1" & goto :next_arg
if "%1"=="--no-run" set "no_run=1" & goto :next_arg
if "%1"=="--no-pause" set "no_pause=1" & goto :next_arg
if "%1"=="--safe" set "safe=1" & goto :next_arg
if "%1"=="--clean" set "make_args=%make_args% -clean" & goto :next_arg
if "%1"=="--dumpint" set "make_args=%make_args% -dumpint" & goto :next_arg

rem Value arguments
set arg_size=2

if "%1"=="--map" (
    for /R "%map_dir%" %%f in (%2.rom?) do (
        set map=%2
        goto :next_arg
    )

    echo ERROR: Invalid value '%2' for argument '--map'. Map not found.
    goto :error_exit
)

rem Other arguments
set arg_size=1
if not "%1"=="" set arg_tail=%arg_tail% %1

:next_arg
for /l %%i in (1,1,%arg_size%) do shift /1
if not "%1"=="" goto :parse_args_loop

rem End of argument parsing
if %help% neq 0 goto :help
if %no_kill% neq 0 goto :build

rem Check if UCC is running
tasklist /fi "imagename eq %ucc_task%" | find /i "%ucc_task%" >nul
if %ERRORLEVEL% neq 0 goto :build
echo Found a running UCC process.

rem Check safe mode
if %safe% equ 0 goto :prompt_kill_ucc
if not exist %lock_file% (
    echo WARNING: Lock file '%lock_file%' not found, '--safe' flag is ignored.
    goto :prompt_kill_ucc
)

rem Check if StdOut.log is used by another process
echo Looking for compilation lock...
powershell -Command "[System.IO.File]::Open('%lock_file%', 'Open', 'Write')" >nul 2>&1 
if %ERRORLEVEL% equ 0 (
    goto :prompt_kill_ucc
)
echo Lock found.
echo Can't terminate UCC while it's compiling. Remove '--safe' flag if you want to kill it anyway.
goto :error_exit

:prompt_kill_ucc
if %always_yes% neq 0 goto :kill_ucc
choice /c yn /m "UCC process will be terminated. Do you wish to continue"
if %ERRORLEVEL% neq 1 exit /b 1

:kill_ucc
echo Terminating the running UCC process...
taskkill /im %ucc_task% /f >nul 2>&1

:build
if %no_build% neq 0 goto :run
echo Starting a build...
cd "%~dp0"
echo 1280 > ..\System\steam_appid.txt
python ..\tools\make\make.py%make_args% -mod DarkestHourDev ..
if %ERRORLEVEL% neq 0 goto :error_exit

:run
if %no_run% neq 0 goto :eof
echo Starting the server on map '%map%'...
python ..\tools\test_multiplayer.py%arg_tail% DarkestHourDev %map%?Game=DH_Engine.DarkestHourGame
if %ERRORLEVEL% neq 0 goto:error_exit
goto :eof

:error_exit
if %no_pause% equ 0 pause
if %ERRORLEVEL% neq 0 (exit /b %ERRORLEVEL%) else (exit /b 1)
