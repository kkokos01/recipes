#!/bin/bash

# Deploy Tandoor Recipes on Docker Desktop for Mac (Apple Silicon)
# This script sets up the environment and starts the containers

set -e

echo "Setting up Tandoor Recipes for local development on Apple Silicon..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

# Check if .env file exists, if not, create it from .env.local
if [ ! -f .env ]; then
    echo "Creating .env file from .env.local..."
    cp .env.local .env
else
    echo ".env file already exists, using existing configuration."
fi

# Create necessary directories
mkdir -p mediafiles
mkdir -p postgresql

# Make sure the script is executable
chmod +x boot.sh

# Build and start the containers
echo "Building and starting containers..."
docker-compose -f docker-compose.local.yml up -d --build

echo "Waiting for services to start..."
sleep 10

# Check if services are running
if docker-compose -f docker-compose.local.yml ps | grep -q "Up"; then
    echo " Tandoor Recipes is now running!"
    echo "Web interface: http://localhost:8000"
    echo "Direct app access: http://localhost:8080"
    echo ""
    echo "Initial setup:"
    echo "1. Visit http://localhost:8000 in your browser"
    echo "2. Create an admin account when prompted"
    echo ""
    echo "Useful commands:"
    echo "- View logs: docker-compose -f docker-compose.local.yml logs -f"
    echo "- Stop services: docker-compose -f docker-compose.local.yml down"
    echo "- Restart services: docker-compose -f docker-compose.local.yml restart"
else
    echo " There was an issue starting the services. Please check the logs:"
    docker-compose -f docker-compose.local.yml logs
    exit 1
fi
