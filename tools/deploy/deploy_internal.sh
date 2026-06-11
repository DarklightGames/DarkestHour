#!/usr/bin/env bash

set -e

pushd "$(dirname ${BASH_SOURCE:0})" > /dev/null

# Ownership is screwy when mounting the folder in the container.
git config --global --add safe.directory /RedOrchestra

# Clean localization
echo "Cleaning localization..."
../localization/localization.sh clean -y

# Build the game (requires wine, UCC etc.)
echo "Building the game..."
../make/clean.sh

# Sync localizations.
echo "Syncing localizations"
../localization/localization.sh sync

virtualenv venv --clear && \
source venv/bin/activate && \
pip install -r requirements.txt && \
python3 deploy.py -mod DarkestHourDev /RedOrchestra

popd > /dev/null
