FROM ubuntu
MAINTAINER "Patrick O'Doherty <p@trickod.com>"

EXPOSE 9001
ENV VERSION 0.2.5.10

RUN apt-get update && apt-get install -y \
   build-essential \
   curl \
   libevent-dev \
   libssl-dev

# Get signing keys securely
# Ref: https://www.torproject.org/docs/signing-keys.html.en
RUN mkdir /tmp/gpg
RUN chmod 700 /tmp/gpg
# Roger Dingledine
RUN gpg --homedir /tmp/gpg --keyserver keys.gnupg.net --recv 19F78451
RUN gpg --homedir /tmp/gpg --export F65CE37F04BA5B360AE6EE17C218525819F78451 | gpg --import -
# Nick Mathewson
RUN gpg --homedir /tmp/gpg --keyserver keys.gnupg.net --recv 165733EA
RUN gpg --homedir /tmp/gpg --export B35BF85BF19489D04E28C33C21194EBB165733EA | gpg --import -
RUN rm -rf /tmp/gpg

WORKDIR /tmp/

RUN curl https://dist.torproject.org/tor-${VERSION}.tar.gz > tor.tar.gz
RUN curl https://dist.torproject.org/tor-${VERSION}.tar.gz.asc > tor.tar.gz.asc

# Verify source tarball
RUN gpg --verify tor.tar.gz.asc

RUN tar xzf tor.tar.gz
RUN rm tor.tar.gz tor.tar.gz.asc

WORKDIR /tmp/tor-${VERSION}
RUN ./configure
RUN make
RUN make install

ADD ./torrc /etc/torrc
# Allow you to upgrade your relay without having to regenerate keys
VOLUME /.tor


# Generate a random nickname for the relay
RUN echo "Nickname docker$(head -c 16 /dev/urandom  | sha1sum | cut -c1-10)" >> /etc/torrc

CMD /usr/local/bin/tor -f /etc/torrc
