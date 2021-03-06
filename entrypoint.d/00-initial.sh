#!/bin/bash
# Entrypoint for deltabg/icinga2
# Initial

# If Icinga 2 is not installed
if ! $_ICINGA2_INSTALLED; then

    # Copy original Icinga2 configs in /etc/icinga2.
    echo "Entrypoint: Creating configuration files."
    cp -a /etc/icinga2.dist/* /etc/icinga2/
    chown -R nagios:root /etc/icinga2

fi

# Create directory /var/lib/icinga2.
echo "Entrypoint: Create directory /var/lib/icinga2."
mkdir -p /var/lib/icinga2
chown -R nagios:nagios /var/lib/icinga2

# Create directory /var/log/icinga2.
echo "Entrypoint: Create directory /var/log/icinga2."
mkdir -p /var/log/icinga2
chown -R nagios:adm /var/log/icinga2

# If Icinga 2 is not installed
if ! $_ICINGA2_INSTALLED; then

    # Create directory /usr/lib/nagios/plugins and copy original plugins.
    echo "Entrypoint: Create directory /usr/lib/nagios/plugins."
    mkdir -p /usr/lib/nagios/plugins
    cp -a /usr/lib/nagios/plugins.dist/* /usr/lib/nagios/plugins/
    chown root:root /usr/lib/nagios/plugins

fi
