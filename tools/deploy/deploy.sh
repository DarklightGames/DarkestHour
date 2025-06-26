# usr/bin/bash

set -e

CONTAINER_NAME=dh-deploy

pushd "$(dirname ${BASH_SOURCE:0})" > /dev/null

# Make sure the username is passed.

docker build . -t $CONTAINER_NAME
docker run --mount type=bind,src="$(realpath ../..)",dst=/RedOrchestra -it $CONTAINER_NAME

trap popd EXIT > /dev/null
