# Base on Ubuntu 16.04 LTS
FROM ubuntu:16.04

# Yocto dependencies (for Yocto 2.2)
RUN DEBIAN_FRONTEND="noninteractive" apt-get -q update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -qq install -y \
        gawk wget git-core diffstat unzip texinfo gcc-multilib \
        build-essential chrpath socat libsdl1.2-dev xterm \
        cpio python3 && \
    apt-get -q clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -f /var/cache/apt/*.bin && \
    rm -fr /usr/share/man/*

# Set up locale to make Python and BitBake happy
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# A minimal init system for Linux containers
#  https://engineeringblog.yelp.com/2016/01/dumb-init-an-init-for-docker.html
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

# Add group/user
RUN groupadd -g 1000 buildgroup
RUN useradd --create-home -d /var/build -s /bin/bash -u 1000 -g 1000 builduser

# Use bash instead of dash for /bin/sh
RUN ln -sf bash /bin/sh

USER builduser
WORKDIR /var/build
