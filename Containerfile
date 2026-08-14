FROM ubuntu:26.04 AS source

ADD --checksum=sha256:d12fb8c8eac1aecd2dfb6377acd48f994f8fa439ed5292fa532dd82880f029fd https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.4.2/OrcaSlicer_Linux_AppImage_Ubuntu2404_V2.4.2.AppImage /tmp/source

RUN chmod 0755 /tmp/source && \
    cd /tmp && \
    ./source --appimage-extract >/dev/null && \
    mv /tmp/squashfs-root /out

FROM ghcr.io/containerpak/gtk3:main

COPY --from=source /out /opt/orcaslicer
COPY icon.png /usr/share/icons/hicolor/128x128/apps/orcaslicer.png

RUN mkdir -p /usr/share/applications && \
    printf '#!/bin/sh\nexec /opt/orcaslicer/AppRun "$@"\n' > /usr/bin/orcaslicer && \
    chmod 0755 /usr/bin/orcaslicer && \
    printf '[Desktop Entry]\nName=OrcaSlicer\nExec=orcaslicer %F\nIcon=orcaslicer\nType=Application\nCategories=Graphics;3DGraphics;\n' > /usr/share/applications/com.orcaslicer.OrcaSlicer.desktop && \
    cpak-clean-junk
