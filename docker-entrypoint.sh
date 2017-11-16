#!/bin/bash
set -e

# Add kibana as command if needed
if [[ "$1" == -* ]]; then
    set -- kibana "$@"
fi

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; then
    if [ "$ELASTICSEARCH_URL" ]; then
        sed -i "/elasticsearch.url/c\elasticsearch.url: $ELASTICSEARCH_URL" /etc/kibana/kibana.yml
    fi
    if [ "$ELASTICSEARCH_USERNAME" ]; then
        sed -i "/elasticsearch.user/c\elasticsearch.username: $ELASTICSEARCH_USERNAME" /etc/kibana/kibana.yml
    fi
    if [ "$ELASTICSEARCH_PASSWORD" ]; then
        sed -i "/elasticsearch.pass/c\elasticsearch.password: $ELASTICSEARCH_PASSWORD" /etc/kibana/kibana.yml
    fi
    if [ "$ELASTICSEARCH_CUSTOMHEADERS" ]; then
        sed -i "/elasticsearch.customHeaders/c\elasticsearch.customHeaders: $ELASTICSEARCH_CUSTOMHEADERS" /etc/kibana/kibana.yml
    fi
    if [ "$KIBANA_INDEX" ]; then
        sed -i "/kibana.index/c\kibana.index: $KIBANA_INDEX" /etc/kibana/kibana.yml
    fi
    if [ "$ELASTICSEARCH_PRESERVEHOST" ]; then
        sed -i "/elasticsearch.preserveHost/c\elasticsearch.preserveHost: $ELASTICSEARCH_PRESERVEHOST" /etc/kibana/kibana.yml
    fi
    if [ "$SERVER_HOST" ]; then
        sed -i "/server.host:/c\server.host: $SERVER_HOST" /etc/kibana/kibana.yml
    fi

    set -- gosu kibana tini -- "$@"
fi

exec "$@"