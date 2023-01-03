# build with: `docker build --tag 'linuxcnc-config-test' .`

FROM debian:bullseye

ARG DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:20

RUN ( \
    apt-get update --quiet; \
    apt-get install --quiet --yes \
        wget \
        x11vnc \
        xvfb \
    ; \
    apt-get clean; \
)

RUN ( \
    wget http://buildbot2.highlab.com/buildbot-archive-key.gpg; \
    mv buildbot-archive-key.gpg /etc/apt/trusted.gpg.d/; \
    echo "deb http://buildbot2.highlab.com/debian bullseye 2.9-uspace" >| /etc/apt/sources.list.d/linuxcnc-buildbot.list; \
    apt-get update --quiet; \
    apt-get install --quiet --yes linuxcnc-uspace; \
    apt-get clean; \
)

RUN ( \
    adduser --disabled-password --gecos "" testrunner; \
    passwd -d testrunner; \
)

RUN ( \
    su -c 'mkdir -p /home/testrunner/linuxcnc/nc_files' testrunner; \
    chmod 0777 $(find /usr/share/doc/linuxcnc/examples/sample-configs/ -type d); \
)

# start script:
#    Xvfb ${DISPLAY} -screen 0 1600x1200x16 &
#    x11vnc -passwd mypw -display ${DISPLAY} -N -forever &

# test:
#    su -c 'linuxcnc /usr/share/doc/linuxcnc/examples/sample-configs/sim/touchy/touchy.ini' testrunner
