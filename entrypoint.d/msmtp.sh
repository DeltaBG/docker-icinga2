#!/bin/bash
# Entrypoint for deltabg/icinga2

echo "Entrypoint: Configure /etc/aliases."
cat <<EOF > /etc/aliases
root:$MSMTP_USER
default:$MSMTP_USER
EOF

echo "Entrypoint: Configure /etc/msmtprc."
cat <<EOF > /etc/msmtprc
# Set default values for all following accounts.
defaults

auth           on
tls            $MSMTP_TLS
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        /var/log/msmtp.log
aliases        /etc/aliases

# Gmail
account        $MSMTP_ACCOUNT
host           $MSMTP_HOST
port           $MSMTP_PORT
from           $MSMTP_FROM
user           $MSMTP_USER
password       $MSMTP_PASSWORD

# Set a default account
account default: $MSMTP_ACCOUNT
EOF

echo "Entrypoint: Set mail transport agent to use msmtp."
echo "set mta=/usr/bin/msmtp" >> /etc/mail.rc

echo "Entrypoint: Configure mail aliases in /etc/mail.rc."
echo "alias root $MSMTP_USER" >> /etc/mail.rc
