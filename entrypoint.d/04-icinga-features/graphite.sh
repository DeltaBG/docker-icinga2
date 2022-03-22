#!/bin/bash
# Entrypoint for deltabg/icinga2
# Icinga 2 feature Graphite

# Export environment constants
export _ICINGA2_FEATURE_GRAPHITE_INSTALLED_FILE=/etc/icinga2/installed_graphite

# Default is not installed
export _ICINGA2_FEATURE_GRAPHITE_INSTALLED=false

# Check Icinga 2 Feature Graphite is installed.
if [ -f "$_ICINGA2_FEATURE_GRAPHITE_INSTALLED_FILE" ]; then
    export _ICINGA2_FEATURE_GRAPHITE_INSTALLED=true
fi

# If Icinga 2 feature Graphite is enable
if $ICINGA2_FEATURE_GRAPHITE; then

    # Enable and setting up Icinga2 feature Graphite.
    echo "Entrypoint: Enable and setting up Icinga2 feature Graphite."
    icinga2 feature enable graphite
    cat <<EOF > /etc/icinga2/features-available/graphite.conf
/**
 * The GraphiteWriter type writes check result metrics and
 * performance data to a graphite tcp socket.
 */

library "perfdata"

object GraphiteWriter "graphite" {
  host = "$ICINGA2_FEATURE_GRAPHITE_HOST"
  port = "$ICINGA2_FEATURE_GRAPHITE_PORT"
  enable_send_thresholds = $ICINGA2_FEATURE_GRAPHITE_SEND_THRESHOLDS
  enable_send_metadata = $ICINGA2_FEATURE_GRAPHITE_SEND_METADATA
}
EOF

else

    # Disable Icinga 2 feature Graphite.
    echo "Entrypoint: Disable Icinga2 feature Graphite."
    icinga2 feature disable graphite

fi
