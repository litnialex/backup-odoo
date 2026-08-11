FROM alpine:3.18.4

RUN apk add --no-cache tini postgresql-client gnupg tzdata py3-pip py3-magic curl &&\
    cp /usr/share/zoneinfo/Europe/Prague /etc/localtime &&\ 
    echo "Europe/Moscow" > /etc/timezone &&\ 
    apk del tzdata && rm -rf /var/cache/apk/* && \
    pip install s3cmd

ENV DUPLICACY=2.7.2
RUN curl -L -o /usr/local/bin/duplicacy \
    https://github.com/gilbertchen/duplicacy/releases/download/v${DUPLICACY}/duplicacy_linux_x64_${DUPLICACY} ; \
    chmod +x /usr/local/bin/duplicacy

COPY backup.sh /root/
COPY crontab /etc/crontabs/root

RUN apk add msmtp

CMD /sbin/tini -- /usr/sbin/crond -f -d 8 -l 8
