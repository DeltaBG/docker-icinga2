#!/bin/bash
# Entrypoint for deltabg/icinga2
# Database

# Create Icinga 2 IDO MySQL Database and User.
echo "Entrypoint: Create Icinga 2 IDO MySQL Database and User."
mysql -h$ICINGA2_MYSQL_HOST \
    -P$ICINGA2_MYSQL_PORT \
    -u$MYSQL_ROOT_USER \
    -p$MYSQL_ROOT_PASSWORD \
    -e"CREATE DATABASE IF NOT EXISTS $ICINGA2_MYSQL_DB;
       CREATE USER IF NOT EXISTS '$ICINGA2_MYSQL_USER'@'%' IDENTIFIED BY '$ICINGA2_MYSQL_PASSWORD';
       GRANT ALL ON $ICINGA2_MYSQL_DB . * TO '$ICINGA2_MYSQL_USER'@'%';"

# If Icinga 2 is not installed
if ! $_ICINGA2_INSTALLED; then

    # Import the Icinga2 IDO schema.
    echo "Entrypoint: Import the Icinga2 IDO schema."
    mysql -h$ICINGA2_MYSQL_HOST \
        -P$ICINGA2_MYSQL_PORT \
        -u$ICINGA2_MYSQL_USER \
        -p$ICINGA2_MYSQL_PASSWORD \
        $ICINGA2_MYSQL_DB < /usr/share/icinga2-ido-mysql/schema/mysql.sql

fi
