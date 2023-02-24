This repo automates testing of all the LinuxCNC sim configs.


# Setup

## Install dependencies

`apt-get install python3 python3-rich docker.io vncsnapshot`

(Needs python3 >= 3.8)


## Build the docker image

The Dockerfile is based on debian:bookworm, change this if you want to
run the tests on a different platform.

`docker pull debian:bookworm`
`docker build --file=Dockerfile.x11 --tag=linuxcnc-config-test-x11 .`

This makes a minimal docker image based on debian:bookworm, with the
latest linuxcnc-uspace deb installed from the linuxcnc buildbot.

This image has xvfb and x11vnc, so it can run GUI applications and the
docker host can screenshot the screen.

This image is suitable for running LinuxCNC's sim configs.


# Run the tests

`./config-test`

The test program will inspect the docker image created during Setup and
list all the sim configs.

For each sim config it then does this:
* start a docker container
* start linuxcnc with this config
* if linuxcnc exits within 10 seconds we call it a failure, if it doesn't exit we call it success
* take a screenshot & save linuxcnc's stdout and stderr in `results/`
* clean up the container
