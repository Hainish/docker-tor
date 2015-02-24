#!/bin/bash
apt-get update && apt-get install -y \
 build-essential \
 curl \
 libevent-dev \
 libssl-dev

# Get signing keys securely
# Ref: https://www.torproject.org/docs/signing-keys.html.en
mkdir /tmp/gpg
chmod 700 /tmp/gpg
# Roger Dingledine
gpg --homedir /tmp/gpg --keyserver keys.gnupg.net --recv 19F78451
gpg --homedir /tmp/gpg --export F65CE37F04BA5B360AE6EE17C218525819F78451 | gpg --import -
# Nick Mathewson
gpg --homedir /tmp/gpg --keyserver keys.gnupg.net --recv 165733EA
gpg --homedir /tmp/gpg --export B35BF85BF19489D04E28C33C21194EBB165733EA | gpg --import -
rm -rf /tmp/gpg

cd /tmp/

curl https://dist.torproject.org/tor-${VERSION}.tar.gz > tor.tar.gz
curl https://dist.torproject.org/tor-${VERSION}.tar.gz.asc > tor.tar.gz.asc

# Verify source tarball, only continue if verified
gpg --verify tor.tar.gz.asc &&

tar xzf tor.tar.gz
rm tor.tar.gz tor.tar.gz.asc

cd /tmp/tor-${VERSION}
./configure
make
make install
rm -rf /tmp/tor-${VERSION}

apt-get remove -y --purge \
  build-essential \
  curl \
  libevent-dev \
  libssl-dev
