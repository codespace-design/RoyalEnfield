#!/bin/bash

# Update system
sudo apt-get update

# Install system dependencies for Django and MySQL
sudo apt-get install -y \
    python3-dev \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    python3-pip \
    python3-venv \
    git

# Optional: Install and start MySQL if not using RDS
# sudo apt-get install -y mysql-server
# sudo systemctl start mysql

echo "System dependencies installed successfully."
echo "Now you can create a venv and run: pip install -r requirements.txt"
