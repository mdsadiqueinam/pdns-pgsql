#!/bin/bash

createConf() {
  property_names=$(grep -oP "[0-9a-z-_]*=" /usr/local/bin/pdns.conf | awk -F= '{print $1}' | tr '\n' ' ')

  for name in $property_names
  do
    # Converting name to upper case and replace "-" with "_" and also remove all space and #
    var_name=$(echo "$name" | tr 'a-z-' 'A-Z_')

    # Check if the environment variable with the var_name is set
    var_value=$(eval echo \$"$var_name")
    if [ -n "$var_value" ]; then
      # Replace the value in the pdns.conf file and stripped_name should start from the beginning of the line
      sed -i "s/.*$name=.*/$name=$var_value/g" /etc/pdns/pdns.conf
    else
      echo "$var_name environment variable not available."
    fi
  done
}

concatConf() {
  GPGSQL_HOST=${GPGSQL_HOST:-localhost}
  GPGSQL_PORT=${GPGSQL_PORT:-5432}
  GPGSQL_DB=${GPGSQL_DB:-pdns_db}
  GPGSQL_USER=${GPGSQL_USER:-postgres}
  GPGSQL_PASS=${GPGSQL_PASS:-postgres}
  GPGSQL_DNSSEC=${GPGSQL_DNNSEC:-yes}
  GPGSQL_EXTRA_CONNECTION_PARAMETERS=${GPGSQL_EXTRA_CONNECTION_PARAMETERS:-""}
  GPGSQL_PREPARED_STATEMENTS=${GPGSQL_PREPARED_STATEMENTS:-yes}
  PDNS_API_KEY=${PDNS_API_KEY:-changeme}

  cat << EOF >> /etc/pdns/pdns.conf

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
}

createConf
concatConf

exec /usr/sbin/pdns_server --daemon=no --guardian=no --loglevel=9 --log-dns-details=on