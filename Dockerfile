# Dockerfile for deltabg_icinga2
# https://git.maniaci.net/DeltaBG/docker-icinga2

FROM ubuntu:focal

VOLUME ["/etc/icinga2", "/usr/lib/nagios/plugins"]

# Update system and install requirements
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install apt-transport-https curl gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Icinga2
RUN export DEBIAN_FRONTEND=noninteractive \
    && curl -s https://packages.icinga.com/icinga.key | apt-key add - \
    && echo "deb https://packages.icinga.com/ubuntu icinga-focal main" > /etc/apt/sources.list.d/icinga.list \
    && echo "deb-src https://packages.icinga.com/ubuntu icinga-focal main" >> /etc/apt/sources.list.d/icinga.list \
    && apt-get update \
    && apt-get -y install \
        icinga2 \
        icinga2-ido-mysql \
        monitoring-plugins \
        nagios-nrpe-plugin \
        nagios-plugins-contrib \
        nagios-snmp-plugins \
        libmonitoring-plugin-perl \
        pwgen \
        msmtp-mta \
        mailutils \
        bsd-mailx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && /usr/lib/icinga2/prepare-dirs /etc/default/icinga2 \
    # Copy original configs in /etc/icinga2.dist/
    && cp -a /etc/icinga2 /etc/icinga2.dist \
    # Copy original nagios plugins to /usr/lib/nagios/plugins.dist
    && cp -a /usr/lib/nagios/plugins /usr/lib/nagios/plugins.dist

# Copy entrypoint.d, entrypoint.sh and healthcheck.sh scripts
ADD entrypoint.d/ /entrypoint.d/
COPY entrypoint.sh /
COPY healthcheck.sh /

HEALTHCHECK --interval=10s --timeout=10s --retries=9 --start-period=5s CMD /healthcheck.sh

EXPOSE 5665

ENTRYPOINT ["/entrypoint.sh"]
