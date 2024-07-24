# DevOpsFetch

DevOpsFetch is a powerful command-line tool designed for DevOps professionals to quickly retrieve and display system information, including active ports, Docker containers, Nginx configurations, user logins, and system activities within specified time ranges.

## Features

- Active port and service monitoring
- Docker image and container management
- Nginx domain and configuration inspection
- User login tracking
- Time-based activity logging
- Continuous monitoring via systemd service
- Formatted output for improved readability

## Table of Contents
1. [Installation](#installation)
2. [Configuration](#configuration)
3. [Usage](#usage)
   - [Port Information](#port-information)
   - [Docker Information](#docker-information)
   - [Nginx Information](#nginx-information)
   - [User Information](#user-information)
   - [Time Range Activities](#time-range-activities)
   - [Help](#help)
4. [Logging Mechanism](#logging-mechanism)
5. [Troubleshooting](#troubleshooting)

## Installation

To install DevOpsFetch, follow these steps:

1. Clone this repository:
git clone https://github.com/your-username/devopsfetch.git
cd devopsfetch
2. Run the installation script:
sudo ./install_devopsfetch.sh
This script will:
- Install necessary dependencies (jq, nginx, docker.io)
- Copy the DevOpsFetch script to /usr/local/bin/
- Set up a systemd service for continuous monitoring
- Configure log rotation

## Configuration

After installation, you can configure the systemd service by editing its unit file:
sudo nano /etc/systemd/system/devopsfetch.service

You can modify the `ExecStart` line to change how often the tool runs or what command it executes.
After making changes, reload the systemd daemon and restart the service:

sudo systemctl daemon-reload
sudo systemctl restart devopsfetch.service

## Usage

DevOpsFetch can be used with various command-line flags:

### Port Information
- Display all active ports:
devopsfetch -p
- Display information for a specific port:
devopsfetch -p 80
### Docker Information
- List all Docker images and containers:
devopsfetch -d
- Display information for a specific container:
devopsfetch -d my_container_name
### Nginx Information
- Display all Nginx domains and their ports:
- 
```devopsfetch -n```

#- Display configuration for a specific domain
devopsfetch -n example.com
### User Information
- List all users and their last login times:
devopsfetch -u username
### Time Range Activities
- Display system activities within a specified time range:
devopsfetch -t "2023-07-24 00:00:00" "2023-07-24 23:59:59"
### Help
- Display usage instructions:
devopsfetch -h
## Logging Mechanism

DevOpsFetch uses systemd for logging. Logs are stored in the system journal and a dedicated log file.

To view the systemd service logs:

sudo journalctl -u devopsfetch.service

To view the dedicated log file:
sudo cat /var/log/devopsfetch.log
## Troubleshooting

If you encounter issues:

1. Check the service status:
sudo systemctl status devopsfetch.service
2. View recent logs:
sudo journalctl -u devopsfetch.service -n 50 --no-pager
3. Ensure the script has correct permissions:
sudo chmod +x /usr/local/bin/devopsfetch
4. Verify the script content:
sudo cat /usr/local/bin/devopsfetch
5. If changes are made to the script, restart the service:
sudo systemctl restart devopsfetch.service
