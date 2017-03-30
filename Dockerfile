FROM kibana:4.5

RUN /opt/kibana/bin/kibana plugin -i elastic/timelion
RUN /opt/kibana/bin/kibana plugin -i elastic/sense

COPY docker-entrypoint.sh /
