
#
# Setup Stage: install apps
#
# This is a dedicated stage so that donwload archives don't end up on 
# production image and consume unnecessary space.
#

FROM ubuntu:24.04 as setup


ENV IB_GATEWAY_VERSION=10.30.1t
ENV IB_GATEWAY_RELEASE_CHANNEL=stable
ENV IBC_VERSION=3.20.0

WORKDIR /tmp/setup

# Prepare system
RUN apt-get update -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
  curl \
  ca-certificates \
  unzip \
  libnspr4 libnss3 libcrypto++8 xdg-utils xfce4-cpugraph-plugin \
  xfce4-netload-plugin xfce4-taskmanager xfce4-xkb-plugin xfce4-notes \
  gvfs gvfs-backends gvfs-fuse && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install IB Gateway
# Use this instead of "RUN curl .." to install a local file:
#COPY ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh .
RUN curl -sSL https://github.com/UnusualAlpha/ib-gateway-docker/releases/download/ibgateway-${IB_GATEWAY_RELEASE_CHANNEL}%40${IB_GATEWAY_VERSION}/ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh \
  --output ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh
RUN curl -sSL https://github.com/UnusualAlpha/ib-gateway-docker/releases/download/ibgateway-${IB_GATEWAY_RELEASE_CHANNEL}%40${IB_GATEWAY_VERSION}/ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh.sha256 \
  --output ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh.sha256
RUN sha256sum --check ./ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh.sha256
RUN chmod a+x ./ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh
RUN ./ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh -q -dir /root/Jts/ibgateway/${IB_GATEWAY_VERSION}

#Install IB TWS
RUN curl -sSL https://github.com/bondjames12/tbot-tradingboat/releases/download/tws${IB_GATEWAY_VERSION}/tws-${IB_GATEWAY_RELEASE_CHANNEL}-x64-${IB_GATEWAY_VERSION}.sh \
  --output tws-standalone-linux-x64.sh
RUN chmod a+x ./tws-standalone-linux-x64.sh
RUN ./tws-standalone-linux-x64.sh -q -dir /root/Jts/ibgateway/tws
RUN cp -r /root/Jts/ibgateway/tws/ /root/Jts/ibgateway/${IB_GATEWAY_VERSION}/
COPY ./config/ibgateway/jts.ini /root/Jts/jts.ini
RUN sed -i 's/-Xmx768m/-Xmx2048m/' /root/Jts/ibgateway/${IB_GATEWAY_VERSION}/ibgateway.vmoptions

# Install IBC
RUN curl -sSL https://github.com/IbcAlpha/IBC/releases/download/${IBC_VERSION}/IBCLinux-${IBC_VERSION}.zip --output IBCLinux-${IBC_VERSION}.zip
RUN mkdir /root/ibc
RUN unzip ./IBCLinux-${IBC_VERSION}.zip -d /root/ibc
RUN chmod -R u+x /root/ibc/*.sh 
RUN chmod -R u+x /root/ibc/scripts/*.sh
COPY ./config/ibc/config.ini.tmpl /root/ibc/config.ini.tmpl

# Copy scripts
COPY ./scripts /root/scripts

#
# Build Stage: build production image
#

FROM ubuntu:24.04

ENV IB_GATEWAY_VERSION=10.30.1t

WORKDIR /root

# Prepare system
RUN apt-get update -y &&  DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

RUN apt-get install --no-install-recommends --yes \
  gettext \
  xvfb \
  libx11-dev \
  libxext-dev \
  libxi-dev \
  libxtst-dev \
  libxslt-dev \
  libxrender1 \
  libxtst6 \
  libxi6 \
  libgtk2.0-bin \
  socat \
  x11vnc \
  git \
  redis-server \
  wget \
  unzip \
  tmux \
  openssh-client \
  net-tools \
  vim \
  dos2unix \
  telnet \
  libgtk-3-dev

RUN apt install -y \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libc6 \
    libcairo2  \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc-s1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpulse0 \
    libx11-6 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    libxshmfence1 \
    libxtst6 \
    xdg-utils \
    libcrypto++8 \
    liboss4-salsa-asound2

#install rustdesk
RUN wget https://github.com/rustdesk/rustdesk/releases/download/1.3.7/rustdesk-1.3.7-x86_64.deb && \
    dpkg -i rustdesk-1.3.7-x86_64.deb || apt-get install -f -y && \
    rm rustdesk-1.3.7-x86_64.deb

# Copy files
COPY --from=setup /root/ .
RUN chmod a+x /root/scripts/*.sh
COPY --from=setup /usr/local/i4j_jres/ /usr/local/i4j_jres

# IBC env vars
ENV TWS_MAJOR_VRSN ${IB_GATEWAY_VERSION}
ENV TWS_PATH /root/Jts
ENV IBC_PATH /root/ibc
ENV IBC_INI /root/ibc/config.ini
ENV TWOFA_TIMEOUT_ACTION exit

RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa

# TBOT: Set python3.9 as a default python
RUN apt-get install -y python3.9 python3.9-venv python3.9-dev python3.9-distutils python3-pip && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

# TBOT: Create a non-root user and set its home directory
RUN useradd -m tbot

# TBOT: Set the working directory to the user's home directory
WORKDIR /home/tbot

# TBOT: copy environment variables
COPY ./tbot/tbot_run.sh /home/tbot/tbot_run.sh
RUN chmod a+x /home/tbot/tbot_run.sh

# TBOT: Set default git repository and allow user to override
ARG TBOT_TRADINGBOAT_GIT_REPO=https://github.com/bondjames12/tbot-tradingboat.git
ARG TBOT_TRADINGBOAT_GIT_BRANCH=main

ARG TBOT_TVWB_GIT_REPO=https://github.com/bondjames12/tradingview-webhooks-bot.git
ARG TBOT_TVWB_GIT_BRANCH=main

# Add GitHub to known hosts for SSH, copy SSH keys, and clone repository conditionally
COPY ./tbot/* /home/tbot/.ssh/

# Copy the script to detect and copy the SSH key
COPY ./tbot/copy_ssh_key.sh /home/tbot/copy_ssh_key.sh
RUN chmod +x /home/tbot/copy_ssh_key.sh

# TBOT: Set permissions if keys exist
RUN if echo "${TBOT_TRADINGBOAT_GIT_REPO}" | grep -q "git@"; then \
        /home/tbot/copy_ssh_key.sh && \
        chmod 600 /home/tbot/.ssh/id_rsa && \
        ssh-keyscan github.com > /home/tbot/.ssh/known_hosts && \
        git config --global user.email "you@example.com" && \
        git config --global user.name "Your Name" && \
        git config --global core.sshCommand "ssh -i /home/tbot/.ssh/id_rsa -o StrictHostKeyChecking=no"; \
    fi

# TBOT: Install common python libraries for Tradingboat globally
RUN pip install libtmux loguru

# TBOT: create and activate the virtual environment
RUN python3.9 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN . /opt/venv/bin/activate
RUN git clone -b ${TBOT_TRADINGBOAT_GIT_BRANCH} ${TBOT_TRADINGBOAT_GIT_REPO} /home/tbot/develop/github/tbot-tradingboat
WORKDIR /home/tbot/develop/github/tbot-tradingboat
# Install dependencies in the virtual environment
RUN pip install -r requirements.txt
RUN pip install -e .
RUN chmod a+x /home/tbot/develop/github/tbot-tradingboat/tbottmux/*.sh

RUN git clone -b ${TBOT_TVWB_GIT_BRANCH} ${TBOT_TVWB_GIT_REPO} /home/tbot/develop/github/tradingview-webhooks-bot
WORKDIR /home/tbot/develop/github/tradingview-webhooks-bot/src
# Install dependencies in the virtual environment
RUN pip install -r requirements.txt
# TBOT: Set the default directory
WORKDIR /home/tbot/develop/github/tbot-tradingboat

COPY ./scripts/fork_ports_delayed.sh /root/scripts/fork_ports_delayed.sh
COPY ./scripts/run_x11_vnc.sh /root/scripts/run_x11_vnc.sh
RUN dos2unix /root/scripts/*.sh && chmod a+x /root/scripts/*.sh

# Start run script
RUN dos2unix /home/tbot/tbot_run.sh && chmod a+x /home/tbot/tbot_run.sh
CMD ["/home/tbot/tbot_run.sh"]
