#!/usr/bin/env bash

set -e

pushd "$(dirname ${BASH_SOURCE:0})" > /dev/null

# Ownership is screwy when mounting the folder in the container.
git config --global --add safe.directory /RedOrchestra

virtualenv venv
source venv/bin/activate && pip install -r requirements.txt && python3 deploy.py -mod DarkestHourDev /RedOrchestra

popd > /dev/null
