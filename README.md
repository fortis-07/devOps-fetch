# devopsfetch

A comprehensive DevOps tool for server information retrieval and monitoring.

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Command-line Options](#command-line-options)
6. [Continuous Monitoring](#continuous-monitoring)
7. [Logging](#logging)
8. [Troubleshooting](#troubleshooting)

## Overview

devopsfetch is a powerful command-line tool designed for DevOps professionals to quickly retrieve and monitor critical server information. It provides detailed insights into active ports, user logins, Nginx configurations, Docker images, and container statuses.

## Features

- Active port and service monitoring
- Docker image and container management
- Nginx domain and configuration inspection
- User login tracking
- Time-based activity logging
- Continuous monitoring via systemd service
- Formatted output for improved readability

## Installation

To install devopsfetch, run the following commands:

```bash
git clone https://github.com/yourusername/devopsfetch.git
cd devopsfetch
chmod +x install.sh
sudo ./install.sh
