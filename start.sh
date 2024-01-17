#!/bin/bash
GPGSQL_HOST=${GPGSQL_HOST:-host.docker.internal}
GPGSQL_PORT=${GPGSQL_PORT:-5432}
GPGSQL_DB=${GPGSQL_DB:-pdns_db}
GPGSQL_USER=${GPGSQL_USER:-postgres}
GPGSQL_PASS=${GPGSQL_PASS:-postgres}
GPGSQL_DNSSEC=${GPGSQL_DNNSEC:-yes}
GPGSQL_EXTRA_CONNECTION_PARAMETERS=${GPGSQL_EXTRA_CONNECTION_PARAMETERS:-""}
GPGSQL_PREPARED_STATEMENTS=${GPGSQL_PREPARED_STATEMENTS:-yes}
PDNS_API_KEY=${PDNS_API_KEY:-changeme}

cat << EOF > /etc/pdns/pdns.conf
# psql Configuration
#
# Launch gpgsql backend
launch=gpgsql

gpgsql-host=${GPGSQL_HOST}
gpgsql-port=${GPGSQL_PORT}
gpgsql-dbname=${GPGSQL_DB}
gpgsql-user=${GPGSQL_USER}
gpgsql-password=${GPGSQL_PASS}
gpgsql-dnssec=${GPGSQL_DNSSEC}
gpgsql-extra-connection-parameters=${GPGSQL_EXTRA_CONNECTION_PARAMETERS}
gpgsql-prepared-statements=${GPGSQL_PREPARED_STATEMENTS}
EOF

exec /usr/sbin/pdns_server --daemon=no --guardian=no --loglevel=9 --log-dns-details=on --webserver=yes --api=yes --api-key="${PDNS_API_KEY}"