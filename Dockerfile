FROM ubuntu
MAINTAINER "Patrick O'Doherty <p@trickod.com>"

EXPOSE 9001
ENV VERSION 0.2.5.10

ADD download_and_build.sh /tmp/
RUN /tmp/download_and_build.sh

ADD ./torrc /etc/torrc
# Allow you to upgrade your relay without having to regenerate keys
VOLUME /.tor


# Generate a random nickname for the relay
RUN echo "Nickname docker$(head -c 16 /dev/urandom  | sha1sum | cut -c1-10)" >> /etc/torrc

CMD /usr/local/bin/tor -f /etc/torrc
