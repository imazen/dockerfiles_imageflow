# Dockerfiles for Imageflow

Dockerfiles for Imageflow build environments and base OSes

* imageflow_base_os is for deployment; it is not used during build. User `imageflow`
* imageflow_build_ubuntu14 is used for the gcc48 release. User `conan`
* imageflow_build_ubunut16 is used for the gcc54 release. User `conan`


## Building

No special requirements. The build scripts are there for convenience.

## Testing

Clone imazen/imageflow, and invoke ./ci/docker/test.sh [imagename] `imazen/` is auto-prefixed to the first argument.


## FAQ

### Cannot connect to the Docker daemon. Is the docker daemon running on this host?

See https://stackoverflow.com/questions/21871479/docker-cant-connect-to-docker-daemon


OS X only:

```
docker-machine start # start virtual machine for docker
docker-machine env  # it's helps to get environment variables
eval "$(docker-machine env default)" #set environment variables
```
