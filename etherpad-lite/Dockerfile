FROM dockerfile/nodejs
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Prepare etherpad
RUN mkdir /src
WORKDIR /src

# Dependencies based on docs
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
    build-essential     \
    curl                \
    git-core            \
    gzip                \
    libssl-dev          \
    pkg-config          \
    python

RUN wget https://github.com/ether/etherpad-lite/archive/master.zip &&\
    unzip master &&\
    rm -f master.zip &&\
    mv etherpad-lite-master etherpad &&\
    sed '/installDeps.sh/d' etherpad/bin/run.sh -i

WORKDIR /src/etherpad

# Install dependencies
RUN bin/installDeps.sh && npm install sqlite3

# Add the settings
ADD config/ /src/etherpad/

# Install plugins
RUN npm install \
    ep_headings \
    ep_monospace_default \
    ep_print


EXPOSE 9001
VOLUME ["/data"]

CMD ["bin/configure_and_run.sh"]
