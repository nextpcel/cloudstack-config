#!/bin/bash

# Copy Production Files
cp /etc/cloudstack/management/* etc
cp /usr/share/cloudstack-management/webapp/assets/* assets/
cp /usr/share/cloudstack-management/webapp/locales/*.json locales/
cp /usr/share/cloudstack-management/webapp/index.html .
cp /usr/share/cloudstack-management/webapp/error.html .
cp /usr/share/cloudstack-management/webapp/color.less .

# Patch HTML
sed -i -e 's/Apache CloudStack/PCEL Cloud/g' -e 's/CloudStack/PCEL Cloud/g' error.html
sed -i -e 's/CloudStack UI/PCEL Cloud UI/g' -e 's/Apache CloudStack/PCEL Cloud/g' index.html

# Patch Locales
sed -i 's/docs.cloudstack.apache.org/docs.pcel.cloud/g' locales/*.json
sed -i 's/Apache CloudStack/PCEL Cloud/g' locales/*.json
sed -i 's/CloudStack UI/PCEL Cloud UI/g' locales/*.json
sed -i -e 's/Cloudstack/PCEL Cloud/g' -e 's/CloudStack/PCEL Cloud/g' locales/*.json

# Restore 'es' locale from repo
git checkout -- locales/es.json

# copy back to production
cp cloud.ico /usr/share/cloudstack-management/webapp/cloud.ico
cp locales/*.json /usr/share/cloudstack-management/webapp/locales/
cp assets/* /usr/share/cloudstack-management/webapp/assets/
cp color.less /usr/share/cloudstack-management/webapp/color.less
cp index.html /usr/share/cloudstack-management/webapp/index.html
cp error.html /usr/share/cloudstack-management/webapp/error.html

# Validate JSON syntax using jq
CONFIG_FILE="/etc/cloudstack/management/config.json"
if jq empty "$CONFIG_FILE" >/dev/null 2>&1; then
  echo "OK: $CONFIG_FILE -- JSON syntax is valid."
else
  echo "ERROR: $CONFIG_FILE -- Invalid JSON syntax."
  exit 1
fi
