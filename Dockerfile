FROM docker.io/library/alpine:latest AS windows_fonts

WORKDIR /downloads

# Extract fonts from Windows 10 ISO
RUN apk add --no-cache wget 7zip && \
    wget -O win10.iso "http://software-static.download.prss.microsoft.com/pr/download/19042.631.201119-0144.20h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x86FRE_en-us.iso" && \
    7z e win10.iso 'sources/install.wim' && \
    7z e install.wim 'Windows/Fonts/*' && \
    mkdir fonts && \
    mv *.ttf *.ttc fonts/


FROM docker.io/library/alpine:latest

# Set working directory
WORKDIR /downloads

# Set environment variables
ENV LANG=ko_KR.UTF-8 \
    LANGUAGE=ko_KR.UTF-8 \
    LC_ALL=ko_KR.UTF-8 \
    WINEARCH=win32 \
    WINEPREFIX=/kakaotalk


# Install dependencies
RUN echo "x86" > /etc/apk/arch && \
    apk add --no-cache wget ca-certificates wine cabextract

# Prepare winetricks
RUN wget -O winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    mv winetricks /usr/local/bin

# Prepare font
COPY --from=windows_fonts /downloads/fonts /usr/share/fonts/
RUN wget -O nanum_fonts.zip http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip && \
    unzip nanum_fonts.zip -d /usr/share/fonts/ && \
    rm -rf nanum_fonts.zip

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]
