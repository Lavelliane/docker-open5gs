#!/bin/bash

# Script to build images and deploy the 5G roaming scenario to MicroK8s

# Exit on error
set -e

# Check if microk8s is installed
if ! command -v microk8s >/dev/null 2>&1; then
  echo "Error: MicroK8s is not installed. Please install it first."
  echo "sudo snap install microk8s --classic"
  exit 1
fi

# Make sure required MicroK8s addons are enabled
echo "Enabling required MicroK8s addons..."
microk8s enable dns storage ingress registry

# Define the registry URL
REGISTRY="localhost:32000"

# Set build variables
export OPEN5GS_VERSION="v2.7.5"
export UBUNTU_VERSION="jammy"
export NODE_VERSION="20"

# Create namespace
echo "Creating namespace..."
microk8s kubectl apply -f manifests/00-namespace.yaml

# Build base images
echo "Building base Open5GS image..."
cd images/base-open5gs
docker build -t base-open5gs:${OPEN5GS_VERSION} --build-arg OPEN5GS_VERSION=${OPEN5GS_VERSION} --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} .
cd ../..

# Build component images
components=("amf" "ausf" "bsf" "nrf" "nssf" "pcf" "scp" "sepp" "smf" "udm" "udr" "upf")

for component in "${components[@]}"; do
  echo "Building ${component} image..."
  cd images/${component}
  docker build -t ${component}:${OPEN5GS_VERSION} --build-arg OPEN5GS_VERSION=${OPEN5GS_VERSION} --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} .
  
  # Tag and push to MicroK8s registry
  docker tag ${component}:${OPEN5GS_VERSION} ${REGISTRY}/${component}:${OPEN5GS_VERSION}
  docker push ${REGISTRY}/${component}:${OPEN5GS_VERSION}
  
  cd ../..
done

# Update Kubernetes manifests to use local registry
echo "Updating manifests to use local registry..."
sed -i "s|image: \([^:]*\):\(.*\)|image: ${REGISTRY}/\1:\2|g" manifests/*.yaml

# Apply ConfigMaps
echo "Applying ConfigMaps..."
microk8s kubectl apply -f manifests/01-configmaps.yaml

# Deploy MongoDB
echo "Deploying MongoDB..."
microk8s kubectl apply -f manifests/02-mongodb.yaml

# Wait for MongoDB to be ready
echo "Waiting for MongoDB to be ready..."
microk8s kubectl wait --for=condition=ready pod -l app=mongodb -n open5gs --timeout=300s

# Deploy Home Network components
echo "Deploying Home Network components..."
microk8s kubectl apply -f manifests/03-home-network.yaml

# Wait for Home Network components to be ready
echo "Waiting for Home Network components to be ready..."
microk8s kubectl wait --for=condition=ready pod -l network=home -n open5gs --timeout=300s

# Deploy Visited Network components
echo "Deploying Visited Network components..."
microk8s kubectl apply -f manifests/04-visited-network.yaml

# Wait for Visited Network components to be ready
echo "Waiting for Visited Network components to be ready..."
microk8s kubectl wait --for=condition=ready pod -l network=visited -n open5gs --timeout=300s

# Deploy PacketRusher
echo "Deploying PacketRusher..."
microk8s kubectl apply -f manifests/05-packetrusher.yaml

echo "Deployment completed!"
echo "You can check the status with: microk8s kubectl get pods -n open5gs"