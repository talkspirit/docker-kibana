#!/bin/bash
set -e

# Add kibana as command if needed
if [[ "$1" == -* ]]; then
    set -- kibana "$@"
fi

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; then
    if [ "$ELASTICSEARCH_URL" ]; then
        sed -i "/elasticsearch.url/c\elasticsearch.url: $ELASTICSEARCH_URL" /opt/kibana/config/kibana.yml
    fi
    if [ "$ELASTICSEARCH_USERNAME" ]; then
        sed -i "/elasticsearch.user/c\elasticsearch.username: $ELASTICSEARCH_USERNAME" /opt/kibana/config/kibana.yml
    fi
    if [ "$ELASTICSEARCH_PASSWORD" ]; then
        sed -i "/elasticsearch.pass/c\elasticsearch.password: $ELASTICSEARCH_PASSWORD" /opt/kibana/config/kibana.yml
    fi
    if [ "$KIBANA_INDEX" ]; then
        sed -i "/kibana.index/c\kibana.index: $KIBANA_INDEX" /opt/kibana/config/kibana.yml
    fi
    if [ "$ELASTICSEARCH_PRESERVEHOST" ]; then
        sed -i "/elasticsearch.preserveHost/c\elasticsearch.preserveHost: $ELASTICSEARCH_PRESERVEHOST" /opt/kibana/config/kibana.yml
    fi
    if [ "$SERVER_HOST" ]; then
        sed -i "/server.host/c\server.host: $SERVER_HOST" /opt/kibana/config/kibana.yml
    fi

    # plugin timelion
    sed -i  's/@timestamp/timestamp/' /opt/kibana/installedPlugins/timelion/timelion.json
    if [ "$ELASTICSEARCH_DEFAULT_INDEX" ]; then
        sed -i  "s/_all/$ELASTICSEARCH_DEFAULT_INDEX/" /opt/kibana/installedPlugins/timelion/timelion.json
    fi

    echo "sense.defaultServerUrl: $ELASTICSEARCH_URL" >> /opt/kibana/config/kibana.yml

    set -- gosu kibana tini -- "$@"
fi

exec "$@"