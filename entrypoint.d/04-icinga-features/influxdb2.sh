#!/bin/bash
# Entrypoint for deltabg/icinga2
# Icinga 2 feature InfluxDB2

# Export environment constants
export _ICINGA2_FEATURE_INFLUXDB2_INSTALLED_FILE=/etc/icinga2/installed_influxdb2

# Default is not installed
export _ICINGA2_FEATURE_INFLUXDB2_INSTALLED=false

# Check Icinga 2 Feature InfluxDB2 is installed.
if [ -f "$_ICINGA2_FEATURE_INFLUXDB2_INSTALLED_FILE" ]; then
    export _ICINGA2_FEATURE_INFLUXDB2_INSTALLED=true
fi

# If Icinga 2 feature InfluxDB2 is enable
if $ICINGA2_FEATURE_INFLUXDB2; then

    # Enable and setup Icinga 2 feature InfluxDB2.
    echo "Entrypoint: Enable and setup Icinga2 feature InfluxDB2."
    icinga2 feature enable influxdb2
    cat <<EOF > /etc/icinga2/features-available/influxdb2.conf
/**
 * The Influxdb2Writer type writes check result metrics and
 * performance data to an InfluxDB v2 HTTP API
 */

object Influxdb2Writer "influxdb2" {
  host = "$ICINGA2_FEATURE_INFLUXDB2_HOST"
  port = "$ICINGA2_FEATURE_INFLUXDB2_PORT"
  organization = "$ICINGA2_FEATURE_INFLUXDB2_ORGANIZATION"
  bucket = "$ICINGA2_FEATURE_INFLUXDB2_BUCKET"
  auth_token = "$ICINGA2_FEATURE_INFLUXDB2_AUTH_TOKEN"
  flush_threshold = $ICINGA2_FEATURE_INFLUXDB2_FLUSH_THRESHOLD
  flush_interval = $ICINGA2_FEATURE_INFLUXDB2_FLUSH_INTERVAL
  host_template = {
    measurement = "\$host.check_command\$"
    tags = {
      hostname = "\$host.name\$"
    }
  }
  service_template = {
    measurement = "\$service.check_command\$"
    tags = {
      hostname = "\$host.name\$"
      service = "\$service.name\$"
    }
  }
}
EOF

else

    # Disable Icinga 2 feature InfluxDB2.
    echo "Entrypoint: Disable Icinga 2 feature InfluxDB2."
    icinga2 feature disable influxdb2

fi
