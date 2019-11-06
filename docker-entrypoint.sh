#!/bin/sh
set -e

echo "Running additional provisioning"

if [ ! -f /mapproxy/mapproxy.yaml ]; then
  mapproxy-util create -t base-config /mapproxy/
fi

if [ ! -f /mapproxy/app.py ]; then
  mapproxy-util create -t wsgi-app -f /mapproxy/mapproxy.yaml /mapproxy/app.py
fi

echo "Start mapproxy"

# --wsgi-disable-file-wrapper is required because of https://github.com/unbit/uwsgi/issues/1126
exec uwsgi --wsgi-disable-file-wrapper --http 0.0.0.0:8080 --wsgi-file /mapproxy/app.py --master --enable-threads --processes $MAPPROXY_PROCESSES --threads $MAPPROXY_THREADS
exit
exec "$@"