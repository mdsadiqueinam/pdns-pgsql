ARG IMAGE=alpine:latest

FROM $IMAGE AS base
RUN apk --no-cache add dumb-init grep
RUN apk add --upgrade pdns pdns-backend-pgsql

COPY ./start.sh /usr/local/bin/start.sh
COPY ./pdns.conf /usr/local/bin/pdns.conf
RUN chmod +x /usr/local/bin/start.sh

#ENTRYPOINT ["dumb-init", "--"]
CMD [ "dumb-init", "sh", "/usr/local/bin/start.sh" ]