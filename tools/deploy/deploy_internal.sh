#!/usr/bin/env bash

set -e

pushd "$(dirname ${BASH_SOURCE:0})" > /dev/null

# Ownership is screwy when mounting the folder in the container.
git config --global --add safe.directory /RedOrchestra

read -p "Enter Steam username: " -r
echo
STEAM_USER=$REPLY

virtualenv venv
source venv/bin/activate && pip install -r requirements.txt && python3 deploy.py -mod DarkestHourDev -username $STEAM_USER /RedOrchestra

popd > /dev/null
