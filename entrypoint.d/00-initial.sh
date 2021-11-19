#!/bin/bash
# Entrypoint for deltabg/icinga2
# Initial

# Copy original Icinga2 configs in /etc/icinga2.
echo "Entrypoint: Creating configuration files."
cp -a /etc/icinga2.dist/* /etc/icinga2/
chown -R nagios:root /etc/icinga2

# Create directory /var/lib/icinga2.
echo "Entrypoint: Create directory /var/lib/icinga2."
mkdir -p /var/lib/icinga2
chown -R nagios:nagios /var/lib/icinga2

# Create directory /var/log/icinga2.
echo "Entrypoint: Create directory /var/log/icinga2."
mkdir -p /var/log/icinga2
chown -R nagios:adm /var/log/icinga2
