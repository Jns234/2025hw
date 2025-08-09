FROM rsyslog/rsyslog:latest

COPY ./conf/rsyslog.conf /etc/rsyslog.conf

EXPOSE 514/udp

RUN start.sh