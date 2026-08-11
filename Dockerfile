FROM alpine:3

RUN apk add --no-cache tini postgresql-client gnupg tzdata py3-pip py3-magic curl s3cmd msmtp

ENV DUPLICACY=3.2.5
RUN curl -L -o /usr/local/bin/duplicacy \
    https://github.com/gilbertchen/duplicacy/releases/download/v${DUPLICACY}/duplicacy_linux_x64_${DUPLICACY} ; \
    chmod +x /usr/local/bin/duplicacy

COPY backup.sh /root/
COPY crontab /etc/crontabs/root

CMD /sbin/tini -- /usr/sbin/crond -f -d 8 -l 8
