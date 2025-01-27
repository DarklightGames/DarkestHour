@echo off
pushd %~dp0
git submodule update --recursive --remote
git submodule status
popd
@echo on
