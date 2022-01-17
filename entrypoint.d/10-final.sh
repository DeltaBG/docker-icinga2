#!/bin/bash
# Entrypoint for deltabg/icinga2
# Final

# Repair configuration directory permission.
echo "Entrypoint: Repair directory permission."
chown -R nagios:root /etc/icinga2
chown -R nagios:nagios /var/lib/icinga2
chown -R nagios:adm /var/log/icinga2
chown root:root /etc/aliases /etc/msmtprc 

# Initial setup is done. Touch installed file.
echo "Entrypoint: Initial setup is done."
touch $_ICINGA2_INSTALLED_FILE
