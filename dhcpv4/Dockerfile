FROM debian:jessie-slim
MAINTAINER  Westerus <westerus@gmail.com>

LABEL manteiner="Westerus <westerus@gmail.com>" \
      description="ISC Kea DHCPv4 Service" \
      version="0.1.0"

ARG PKG_FLAGS_COMMON="-qq -y"
ARG PKG_FLAGS_PERSISTANT="${PKG_FLAGS_COMMON} --no-install-recommends"
ARG PKG_FLAGS_DEV="${PKG_FLAGS_COMMON} --no-install-recommends"
ARG PKGUPDATE="apt-get ${PKG_FLAGS_COMMON} update"
ARG PKGUPGRADE="apt-get ${PKG_FLAGS_COMMON} dist-upgrade"
ARG PKGCLEAN="apt-get ${PKG_FLAGS_COMMON} autoclean"
ARG DELTEMP="rm -rf /var/tmp/* /tmp/* /usr/src/*"
ARG PKGINSTALL="apt-get ${PKG_FLAGS_PERSISTANT} install"
ARG PKGREMOVE="apt-get ${PKG_FLAGS_COMMON} remove"
ARG PKGRPURGE="apt-get ${PKG_FLAGS_COMMON} purge"
ARG LIBREMOVE="dpkg -r --force-depends"
ARG LIBPURGE="dpkg -P --force-depends"
ARG LOCALEGEN="locale-gen $LC_ALL && dpkg-reconfigure locales"

ENV LANG="es_ES.UTF-8" LANGUAGE="es_ES:es" LC_ALL="es_ES.UTF-8" DEBIAN_FRONTEND="noninteractive" TERM="xterm"

ENV KEAURL="https://github.com/isc-projects/kea" KEABRANCH="v1_2_0" KEACONF="/etc/kea/kea.conf"

COPY /rootfs/entry-point.sh /

WORKDIR /usr/src/kea

RUN  $PKGUPDATE \
  && $PKGUPGRADE \
  && $PKGINSTALL libtool \
        autoconf \
        g++ \
        make \
        automake \
        libssl-dev \
        libpq-dev \
        liblog4cplus-dev \
        libboost-dev \
        libboost-system-dev \
        libmysqlclient-dev \
        postgresql-server-dev-all \
        git \
        ca-certificates \
        locales \
  && $LOCALEGEN \
  && git clone $KEAURL -b $KEABRANCH . \
  && autoreconf --install --force --warnings='all' \
  && ./configure --prefix='/usr' \
      --sbindir='${exec_prefix}/bin' \
      --sysconfdir='/etc' \
      --localstatedir='/var' \
      --with-openssl \
      --with-boost-lib-dir='/usr/lib/x86_64-linux-gnu' \
      --with-dhcp-mysql \
      --with-dhcp-pgsql \
  && make -j2 \
  && make install \
  && $LIBPURGE postgresql-server-dev-all \
        libmysqlclient-dev \
        libboost-system-dev \
        libboost-dev \
        liblog4cplus-dev \
        libssl-dev \
  && $PKGPURGE autoconf \
        g++ \
        make \
        git \
        automake \
  && $PKGCLEAN \
  && $DELTEMP

WORKDIR /root

ENTRYPOINT ["/entry-point.sh"]
CMD ["kea-dhcp4","-d","-c","$KEACONF"]
