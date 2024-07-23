#!/bin/bash

# install.sh

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Install dependencies
apt-get update
apt-get install -y jq nginx docker.io

# Copy main script to /usr/local/bin
cp devopsfetch.sh /usr/local/bin/devopsfetch
chmod +x /usr/local/bin/devopsfetch

# Create systemd service file
cat > /etc/systemd/system/devopsfetch.service <<EOL
[Unit]
Description=DevOpsFetch Monitoring Service
After=network.target

[Service]
ExecStart=/usr/local/bin/devopsfetch
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd, enable and start the service
systemctl daemon-reload
systemctl enable devopsfetch.service
systemctl start devopsfetch.service

# Set up log rotation
cat > /etc/logrotate.d/devopsfetch <<EOL
/var/log/devopsfetch.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
EOL

echo "Installation completed successfully and ready to roll."
