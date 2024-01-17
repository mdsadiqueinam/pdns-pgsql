ARG IMAGE=alpine:latest

FROM $IMAGE AS base
RUN apk --no-cache add dumb-init
RUN apk add --upgrade pdns pdns-backend-pgsql

COPY ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

#ENTRYPOINT ["dumb-init", "--"]
CMD [ "dumb-init", "sh", "/usr/local/bin/start.sh" ]