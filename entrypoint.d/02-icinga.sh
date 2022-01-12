#!/bin/bash
# Entrypoint for deltabg/icinga2
# Icinga 2

# Enable and setting up Icinga2 IDO Database.
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

# Enable and setting up Icinga2 API.
echo "Entrypoint: Enable and setting up Icinga2 API."
icinga2 api setup --cn $ICINGA2_CN
cat <<EOF > /etc/icinga2/conf.d/api-users.conf
/**
 * The ApiUser objects are used for authentication against the API.
 */

object ApiUser "$ICINGA2_API_USER" {
  password = "$ICINGA2_API_PASSWORD"
  permissions = [ "*" ]
}
EOF

# Generate TicketSalt in /etc/icinga2/constants.conf.
echo "Entrypoint: Generate TicketSalt in /etc/icinga2/constants.conf."

if $ICINGA2_SATELLITE; then
  echo "Entrypoint: Retrieve certificate from the parent host."
  icinga2 pki save-cert --host $ICINGA2_SATELLITE_PARENT --port $ICINGA2_SATELLITE_PARENT_API_PORT --cert $ICINGA2_SATELLITE_CN.crt --trustedcert /var/lib/icinga2/certs/$ICINGA2_SATELLITE_PARENT
  echo "Entrypoint: Run node setup for a satellite configuration."
  icinga2 node setup --cn $ICINGA2_SATELLITE_CN --zone $ICINGA2_SATELLITE_ZONE_NAME --endpoint $ICINGA2_SATELLITE_PARENT --parent_host $ICINGA2_SATELLITE_PARENT
else
  echo "Entrypoint: Run node setup for a master configuration."
  icinga2 node setup --master --cn $ICINGA2_CN --zone $ICINGA2_ZONE_NAME
fi
