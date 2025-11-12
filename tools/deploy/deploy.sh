# usr/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

set -e

CONTAINER_NAME=dh-deploy

pushd "$(dirname ${BASH_SOURCE:0})" > /dev/null

# Make sure that the git repository is clean!
if [[ 'git status --porcelain | wc -l' -ne 0 ]]; then
    git status
    echo -e "${RED}Git repository has unstaged changes. Deploy cancelled.${NC}"
    exit 1
fi

# Clean localization
../localization/localization clean -y

# Build the game (requires wine, UCC etc.)
../make/clean

# Sync localizations.
../localization/localization sync

# Make sure the username is passed.
docker build . -t $CONTAINER_NAME
docker run --mount type=bind,src="$(realpath ../..)",dst=/RedOrchestra -it $CONTAINER_NAME

trap popd EXIT > /dev/null
