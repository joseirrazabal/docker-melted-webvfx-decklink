FROM debian:8
MAINTAINER Jose Luis Irrazabal<joseirrazabal@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /tmp
WORKDIR /tmp

# mlt
RUN apt-get update && \
    apt-get install -y wget git automake autoconf libtool intltool g++ yasm swig \
    libmp3lame-dev libgavl-dev libsamplerate-dev libxml2-dev ladspa-sdk \
    libjack-dev libsox-dev libsdl-dev libgtk2.0-dev libsoup2.4-dev \
    libqt4-dev libexif-dev libtheora-dev libvdpau-dev libvorbis-dev python-dev

# extras para compilar mlt y funcione melt
RUN apt-get install -y xvfb libgavl1 libsamplerate0 libxml2 libjack0 libsox2 libsdl1.2debian libgtk2.0-0 liboil0.3 libsoup2.4-1 libqt4-opengl libqt4-svg libqtgui4 libexif12 libtheora0 libvdpau1 libvorbis0a libvorbisenc2 libvorbisfile3 libxcb-shm0 libqtwebkit4

# extra configuracion de instalacion mlt
RUN echo "INSTALL_DIR=\"/usr\"" > /tmp/build-melted.conf && echo "SOURCE_DIR=\"/tmp/melted\"" >> /tmp/build-melted.conf && echo "SOURCES_CLEAN=1" >> /tmp/build-melted.conf && echo "AUTO_APPEND_DATE=0" >> /tmp/build-melted.conf && echo "CREATE_STARTUP_SCRIPT=0" >> /tmp/build-melted.conf

# descarga e instalacion mlt
RUN cd /tmp/ && git clone https://github.com/mltframework/mlt-scripts.git && \
    \
    /tmp/mlt-scripts/build/build-melted.sh -c /tmp/build-melted.conf

#webvfx
RUN apt-get install -y libqtwebkit-dev
RUN cd /tmp && git clone https://github.com/joseirrazabal/webvfx.git -b mlt && cd /tmp/webvfx && qmake -r PREFIX=/usr MLT_SOURCE=/tmp/melted/mlt && make install

# eliminando todo lo que se pueda
RUN \
    rm -r /tmp/melted && \
    rm /tmp/build-melted.conf && \
    rm -r /tmp/mlt-scripts && \
    rm -r /tmp/webvfx && \
    \
    apt-get remove -y automake autoconf libtool intltool g++ libmp3lame-dev \
    libgavl-dev libsamplerate-dev libxml2-dev libjack-dev libsox-dev libsdl-dev \
    libgtk2.0-dev liboil-dev libsoup2.4-dev libqt4-dev libexif-dev libtheora-dev \
    libvdpau-dev libvorbis-dev python-dev manpages manpages-dev g++ g++-4.6 git && \
    \
    apt-get -y autoclean && apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

# Melted will be run as user default in userspace
RUN     useradd -m default
USER    default
WORKDIR /home/default
ENV     HOME /home/default

# configuracion por defecto que se puede pisar y script para ejecutar melted
COPY melted.conf /etc/melted/melted.conf
COPY melted.sh /home/default/melted.sh

EXPOSE 5250

#ejecuta melted por salida x virtual
ENTRYPOINT ["/home/default/melted.sh"]
