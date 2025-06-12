#!/bin/bash

# Install PostgreSQL if not already installed
# sudo pacman -S --noconfirm postgresql

# Initialize the database cluster as postgres user
sudo -u postgres initdb --locale=en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'

# Start the PostgreSQL service
sudo systemctl start postgresql

# Enable PostgreSQL to start on boot
sudo systemctl enable postgresql

# Create a new user and database (replace with your desired credentials)
DB_USER="jho"
DB_NAME="mydatabase"
DB_PASSWORD="111"

# Create user with password
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"

# Make the user a superuser (for development only)
sudo -u postgres psql -c "ALTER USER $DB_USER WITH SUPERUSER;"

# Create database owned by the new user
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"

# Configure pg_hba.conf for password authentication
echo "host    all             all             127.0.0.1/32            md5" | sudo tee -a /var/lib/postgres/data/pg_hba.conf

# Restart PostgreSQL to apply changes
sudo systemctl restart postgresql

echo "PostgreSQL setup complete!"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo "Password: $DB_PASSWORD"
echo "Connect with: psql -h 127.0.0.1 -U $DB_USER -d $DB_NAME"
