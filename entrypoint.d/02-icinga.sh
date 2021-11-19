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
icinga2 api setup
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
sed -i "s/^const TicketSalt =.*/const TicketSalt = \"$(pwgen 64 1)\"/g" /etc/icinga2/constants.conf
