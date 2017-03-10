#!/bin/bash


# For os x convenience
if [[ "$(uname -s)" == 'Darwin' ]]; then
	eval "$(docker-machine env default)"
fi

docker images


docker history imazen/imageflow_base_os
docker history imazen/imageflow_build_ubuntu14
docker history imazen/imageflow_build_ubuntu16

#docker run imazen/build_if_gcc48 du -h / | grep '[0-9\.]\+M'

