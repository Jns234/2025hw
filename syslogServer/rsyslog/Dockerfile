FROM rsyslog/rsyslog:latest

COPY ./conf/rsyslog.conf /etc/rsyslog.conf
COPY ./conf/50-default.conf /etc/rsyslog.d/50-default.conf
#COPY ./start.sh /start.sh

#RUN apt update && \ 
#    apt install -y vim curl sudo gpg wget && \
#    curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh

#COPY ./conf/fluent-bit.conf /etc/fluent-bit/fluent-bit.conf

EXPOSE 514/udp
EXPOSE 514/tcp

#RUN chmod +x /start.sh
#CMD [ "/start.sh" ]