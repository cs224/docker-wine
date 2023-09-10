ARG BASE_IMAGE="docker-remote-desktop"
ARG TAG="latest"
FROM ${BASE_IMAGE}:${TAG}

# Install prerequisites
RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        cabextract \
        git \
        gnupg \
        gosu \
        gpg-agent \
        locales \
        p7zip \
        pulseaudio \
        pulseaudio-utils \
        sudo \
        tzdata \
        unzip \
        wget \
        winbind \
        xvfb \
        zenity \
        libvulkan1 \
        libvulkan-dev \
        curl \
        gnupg2 \
        software-properties-common \        
    && rm -rf /var/lib/apt/lists/*  \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -fr /tmp/*

# Install wine
ARG WINE_BRANCH="stable"
RUN wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - \
    && echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --install-recommends winehq-${WINE_BRANCH} \
    && rm -rf /var/lib/apt/lists/*

# Install winetricks
RUN wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/bin/winetricks

# Download gecko and mono installers
COPY download_gecko_and_mono.sh /root/download_gecko_and_mono.sh
RUN chmod +x /root/download_gecko_and_mono.sh \
    && /root/download_gecko_and_mono.sh "$(wine --version | sed -E 's/^wine-//')"

# RUN su wineuser -c 'WINEARCH=win32 WINEPREFIX=/home/wineuser/.wine winecfg' \
#     && su wineuser -c 'WINEARCH=win64 WINEPREFIX=/home/wineuser/.wine64 winecfg' \
#     && su wineuser -c 'WINEARCH=win32 wine wineboot' \
#     \
#     # wintricks
#     && su wineuser -c 'winetricks -q msls31' \
#     && su wineuser -c 'winetricks -q ole32' \
#     && su wineuser -c 'winetricks -q riched20' \
#     && su wineuser -c 'winetricks -q riched30' \
#     && su wineuser -c 'winetricks -q win7' \
#     \
#     # Clean
#     && rm -fr /usr/share/wine/{gecko,mono} \
#     && rm -fr /home/wineuser/{.cache,tmp}/* \
#     && rm -fr /tmp/* \
#     && echo 'Wine Initialized'

COPY src/winescript /usr/local/bin/

# Configure locale for unicode
RUN locale-gen en_US.UTF-8
RUN locale-gen de_DE.UTF-8
ENV LANG de_DE.UTF-8

COPY pulse-client.conf /root/pulse/client.conf
COPY entrypoint.sh /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]
