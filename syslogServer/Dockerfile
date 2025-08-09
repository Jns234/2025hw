FROM rsyslog/rsyslog:latest

COPY ./conf/rsyslog.conf /etc/rsyslog.conf
COPY ./conf/50-default.conf /etc/rsyslog.d/50-default.conf


EXPOSE 514/udp

RUN start.sh