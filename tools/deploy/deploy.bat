@echo off
setlocal enabledelayedexpansion

rem Change to the script directory.
pushd "%~dp0" >nul || (
    echo Error: Failed to change directory to script location.
    exit /b 1
)

rem Make sure that the git repository is clean.
set "GIT_CHANGES="
for /f "delims=" %%A in ('git status --porcelain 2^>nul') do set "GIT_CHANGES=1"
if defined GIT_CHANGES (
    git status
    echo.
    echo Git repository has unstaged changes. Deploy cancelled.
    popd >nul
    exit /b 1
)

rem Resolve the repository root two levels above this script.
for %%I in ("%~dp0..\..") do set "REPO_ROOT=%%~fI"
if not exist "%REPO_ROOT%" (
    echo Error: Repository root "%REPO_ROOT%" not found.
    popd >nul
    exit /b 1
)

echo Using container CLI: docker

rem Start the Docker daemon.
docker desktop start

rem Build the image and capture its ID.
set "IMAGE_ID="
for /f "delims=" %%I in ('docker build -q . 2^>nul') do set "IMAGE_ID=%%I"
if not defined IMAGE_ID (
    echo Error: Docker image build failed.
    popd >nul
    exit /b 1
)

rem Run the container with the repository mounted.
docker run --volume "%REPO_ROOT%":/RedOrchestra:z -it %IMAGE_ID%
set "EXIT_CODE=%ERRORLEVEL%"

popd >nul
exit /b %EXIT_CODE%
