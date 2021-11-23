#!/bin/bash
# Entrypoint for deltabg/icinga2

# Export environment default variables
export DEFAULT_MYSQL_PORT=${DEFAULT_MYSQL_PORT:-3306}
export MYSQL_ROOT_USER=${MYSQL_ROOT_USER:-root}
export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-}

# Export environment variables
export ICINGA2_CN=${ICINGA2_CN:-$(hostname)}
export ICINGA2_ZONE_NAME=${ICINGA2_ZONE_NAME:-${ICINGA2_CN}}

export ICINGA2_MYSQL_HOST=${ICINGA2_MYSQL_HOST:-icinga-mariadb}
export ICINGA2_MYSQL_PORT=${ICINGA2_MYSQL_PORT:-${DEFAULT_MYSQL_PORT}}
export ICINGA2_MYSQL_DB=${ICINGA2_MYSQL_DB:-icinga2}
export ICINGA2_MYSQL_USER=${ICINGA2_MYSQL_USER:-icinga2}
export ICINGA2_MYSQL_PASSWORD=${ICINGA2_MYSQL_PASSWORD:-2agnici}

export ICINGA2_API_USER=${ICINGA2_API_USER:-icingaweb2}
export ICINGA2_API_PASSWORD=${ICINGA2_API_PASSWORD:-2bewagnici}

export ICINGA2_FEATURE_GRAPHITE=${ICINGA2_FEATURE_GRAPHITE:-false}
export ICINGA2_FEATURE_GRAPHITE_HOST=${ICINGA2_FEATURE_GRAPHITE_HOST:-icinga-graphite}
export ICINGA2_FEATURE_GRAPHITE_PORT=${ICINGA2_FEATURE_GRAPHITE_PORT:-2003}
export ICINGA2_FEATURE_GRAPHITE_SEND_THRESHOLDS=${ICINGA2_FEATURE_GRAPHITE_SEND_THRESHOLDS:-true}
export ICINGA2_FEATURE_GRAPHITE_SEND_METADATA=${ICINGA2_FEATURE_GRAPHITE_SEND_METADATA:-false}

# Export environment constants
export _ICINGA2_INSTALLED_FILE=/etc/icinga2/installed

# Check Icinga2 is not yet installed.
if [ ! -f "$_ICINGA2_INSTALLED_FILE" ]; then

    # If so, we perform the initial setup.
    echo "Entrypoint: Start Icinga2 initial setup!"

    # Run Initial script
    /entrypoint.d/00-initial.sh

    # Run Database script
    /entrypoint.d/01-database.sh

    # Run Icinga 2 script
    /entrypoint.d/02-icinga.sh

    # Run Icinga 2 features script
    /entrypoint.d/03-icinga-features.sh

    # Run Final script
    /entrypoint.d/10-final.sh

fi

# Start Icinga2 daemon.
echo "Entrypoint: Start Icinga2 daemon."
/usr/sbin/icinga2 daemon
