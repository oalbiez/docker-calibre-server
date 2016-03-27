FROM python:2.7.11
MAINTAINER olivier.albiez@poloper.org

ENV DATA_DIR /srv/calibre

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        imagemagick \
        wget \
        xdg-utils \
        xz-utils \
 && rm -rf /var/lib/apt/lists/* \
 && PYTHONIOENCODING="utf-8" \
    wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main('/opt')" \
 && mkdir -p $DATA_DIR

WORKDIR /opt/calibre

COPY startup /usr/bin/
RUN chmod +x /usr/bin/startup

VOLUME ["${DATA_DIR}"]
EXPOSE 8080

ENTRYPOINT ["/usr/bin/startup"]