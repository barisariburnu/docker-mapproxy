FROM python:3.5
LABEL maintainer="Barış Arıburnu <barisariburnu@gmail.com>"

ENV MAPPROXY_VERSION 1.11.0
ENV MAPPROXY_PROCESSES 4
ENV MAPPROXY_THREADS 2

RUN set -x \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    python-pil \
    python-yaml \
    libproj-dev \
    libgeos-dev \
    python-lxml \
    libgdal-dev \
    build-essential \
    python-dev \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    python-virtualenv \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash mapproxy \
  && mkdir -p /mapproxy \
  && chown mapproxy /mapproxy

RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org \
  --upgrade pip Pillow Shapely requests geojson uwsgi MapProxy==$MAPPROXY_VERSION

COPY ./docker-entrypoint.sh /

USER mapproxy

VOLUME ["/mapproxy"]

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]