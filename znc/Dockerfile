FROM gliderlabs/alpine:3.1
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

# Install znc
RUN apk-install znc

# Create data directories for znc
RUN mkdir -p /home/znc /data /usr/local/bin &&  \
    chown -R znc:znc /home/znc /data

# Add init script
ADD start-znc /usr/local/bin/

# Set up environment
EXPOSE 6667

ENV HOME /home/znc
WORKDIR /home/znc

CMD ["/usr/local/bin/start-znc"]
