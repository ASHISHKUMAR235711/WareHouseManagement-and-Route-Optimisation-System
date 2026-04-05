#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Installing dependencies..."
pip install -r requirements.txt

echo "Setting up persistent disk directories..."
mkdir -p /var/data/app_data
mkdir -p /var/data/uploads

# If the persistent disk is brand new (doesn't have our JSON files yet),
# copy the default files from the Git repository into the disk before we symlink.
if [ ! -f /var/data/app_data/users.json ]; then
    echo "First deploy detected. Copying default data to persistent disk..."
    cp -r data/* /var/data/app_data/ || true
fi

# Link /data to the persistent disk
echo "Creating symlinks for persistent storage..."
rm -rf data
ln -s /var/data/app_data data

# Link /static/uploads to the persistent disk
mkdir -p static
rm -rf static/uploads
ln -s /var/data/uploads static/uploads

echo "Build complete."
