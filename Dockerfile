FROM debian:bookworm

ARG DEBIAN_FRONTEND=noninteractive

RUN ( \
    set -e; \
    apt-get update --quiet; \
    apt-get install --quiet --yes \
        wget \
        x11vnc \
        xvfb \
    ; \
    apt-get clean; \
)

RUN ( \
    set -e; \
    adduser --disabled-password --gecos "" testrunner; \
    passwd -d testrunner; \
    su -c 'mkdir -p /home/testrunner/linuxcnc/nc_files' testrunner; \
)


#
# Install linuxcnc-uspace.deb from the buildbot.
#

RUN ( \
    set -e; \
    wget http://buildbot2.highlab.com/buildbot-archive-key.gpg; \
    mv buildbot-archive-key.gpg /etc/apt/trusted.gpg.d/; \
    echo "deb http://buildbot2.highlab.com/debian bookworm 2.9-uspace" >| /etc/apt/sources.list.d/linuxcnc-buildbot.list; \
    apt-get update --quiet; \
    apt-get install --quiet --yes linuxcnc-uspace; \
    apt-get clean; \
)


#
# Install a local linuxcnc-uspace.deb.
#

#COPY linuxcnc-uspace_*.deb /tmp
#
#RUN ( \
#    set -e; \
#    apt-get install --quiet --yes /tmp/linuxcnc-uspace_*.deb; \
#    apt-get clean; \
#    rm -f /tmp/linuxcnc-uspace_*.deb; \
#)


#
# Make sample config dirs world-writable, some configs want to write in
# their directory.
#

RUN ( \
    chmod 0777 $(find /usr/share/doc/linuxcnc/examples/sample-configs/ -type d); \
)
