#!/bin/bash
# Clean up Docker resources to free disk space

echo "Cleaning up Docker resources..."

# Remove unused containers
docker container prune -f

# Remove unused images
docker image prune -a -f

# Remove unused volumes
docker volume prune -f

# Remove unused networks
docker network prune -f

# Remove build cache
docker builder prune -a -f

echo "Docker cleanup completed!"
df -h