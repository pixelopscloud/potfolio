#!/bin/bash
echo "Starting pre-deployment tasks..."

# Stop any running application (if applicable)
# pkill -f java  # Uncomment if Java app is running

# Clean deployment directory
if [ -d "/home/ec2-user/deploy" ]; then
    rm -rf /home/ec2-user/deploy/*
    echo "Cleaned deployment directory"
fi

echo "Pre-deployment completed"
