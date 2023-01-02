Make a docker image suitable for testing linuxcnc sim configs.

Get a list of all linuxcnc sim configs.

For each sim config:
    start a docker container
    start linuxcnc with the config
    try to tell if it worked
    take a screenshot after a few seconds
    clean up the continer
