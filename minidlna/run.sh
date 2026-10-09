#!/bin/bash

set -e

# Ensure permissions are correct on data directory
chown minidlna:minidlna /data

CONFIG_PATH=/data/options.json

# Extract our clean UI options natively using jq
FRIENDLY_NAME=$(jq --raw-output '.friendly_name' $CONFIG_PATH)
MEDIA_DIR=$(jq --raw-output '.media_dir' $CONFIG_PATH)
LOG_LEVEL=$(jq --raw-output '.log_level' $CONFIG_PATH)

# Clear or append to the minidlna config file
echo "friendly_name=${FRIENDLY_NAME}" > /etc/minidlna.conf
echo "media_dir=${MEDIA_DIR}" >> /etc/minidlna.conf
echo "log_level=general=${LOG_LEVEL},artwork,database,inotify,scanner,metadata,http,ssdp,tivo=warn" >> /etc/minidlna.conf

echo "Starting MiniDLNA with Friendly Name: ${FRIENDLY_NAME}..."

# Start the service cleanly
service minidlna force-reload

# Keep container alive
tail -f /dev/null
