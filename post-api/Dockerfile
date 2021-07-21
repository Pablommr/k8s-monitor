FROM alpine:3.13.2

COPY entrypoint.sh /entrypoint.sh
COPY schedule.txt /schedule.txt
COPY init.sh /init.sh
RUN apk add curl && \
    chmod 755 /entrypoint.sh /schedule.txt /init.sh && \
    /usr/bin/crontab /schedule.txt

CMD ["/init.sh"]