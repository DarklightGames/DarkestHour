# usr/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

set -e

pushd "$(dirname ${BASH_SOURCE:0})" > /dev/null

# Make sure that the git repository is clean!
if [[ 'git status --porcelain | wc -l' -ne 0 ]]; then
    git status
    echo -e "${RED}Git repository has unstaged changes. Deploy cancelled.${NC}"
    exit 1
fi

# Function to find an available container command (podman or docker)
find_container_cli() {
    if command -v podman &> /dev/null; then
        echo "podman"
    elif command -v docker &> /dev/null; then
        echo "docker"
    else
        echo ""
    fi
}

CONTAINER_CLI=$(find_container_cli)

if [ -z "$CONTAINER_CLI" ]; then
    echo "Error: Neither Podman nor Docker was found. Please install one of them to proceed."
    exit 1
fi

echo "Using container CLI: $CONTAINER_CLI"

# Build the image and capture its ID
# The '-q' flag is supported by both podman and docker build to suppress output and return only the image ID.
IMAGE_ID=$($CONTAINER_CLI build -q .)

# Make sure the username is passed.
$CONTAINER_CLI run --volume "$(realpath ../..)":/RedOrchestra:z -it "$IMAGE_ID"

trap popd EXIT > /dev/null
