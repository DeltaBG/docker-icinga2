#!/bin/bash
# Entrypoint for deltabg/icinga2
# Icinga 2

# Enable and setting up Icinga 2 IDO Database.
echo "Entrypoint: Enable and setting up Icinga2 IDO Database."
icinga2 feature enable ido-mysql
cat <<EOF > /etc/icinga2/features-available/ido-mysql.conf
/**
 * The db_ido_mysql library implements IDO functionality
 * for MySQL.
 */

library "db_ido_mysql"

object IdoMysqlConnection "ido-mysql" {
  user = "$ICINGA2_MYSQL_USER"
  password = "$ICINGA2_MYSQL_PASSWORD"
  host = "$ICINGA2_MYSQL_HOST"
  port = $ICINGA2_MYSQL_PORT
  database = "$ICINGA2_MYSQL_DB"
}
EOF

# If Icinga 2 is not installed
if ! $_ICINGA2_INSTALLED; then

    # Enable and setting up Icinga 2 API.
    echo "Entrypoint: Enable and setting up Icinga2 API."
    icinga2 api setup --cn $ICINGA2_CN
    cat <<EOF > /etc/icinga2/conf.d/api-user-default.conf
/**
 * This API user is used by default by Icinga Web 2. If you need other API users, please add them to a new file in the conf.d/. 
 */

object ApiUser "$ICINGA2_API_USER" {
  password = "$ICINGA2_API_PASSWORD"
  permissions = [ "*" ]
}
EOF

fi

# If Icinga 2 is not installed
if ! $_ICINGA2_INSTALLED; then

    if $ICINGA2_SATELLITE; then
        echo "Entrypoint: Retrieve certificate from the parent host."
        icinga2 pki save-cert --host $ICINGA2_SATELLITE_PARENT --port $ICINGA2_SATELLITE_PARENT_API_PORT --cert $ICINGA2_SATELLITE_CN.crt --trustedcert /var/lib/icinga2/certs/$ICINGA2_SATELLITE_PARENT
        echo "Entrypoint: Run node setup for a satellite configuration."
        icinga2 node setup --cn $ICINGA2_SATELLITE_CN --zone $ICINGA2_SATELLITE_ZONE_NAME --endpoint $ICINGA2_SATELLITE_PARENT --parent_host $ICINGA2_SATELLITE_PARENT
    else
        echo "Entrypoint: Run node setup for a master configuration."
        icinga2 node setup --master --cn $ICINGA2_CN --zone $ICINGA2_ZONE_NAME
    fi

fi
