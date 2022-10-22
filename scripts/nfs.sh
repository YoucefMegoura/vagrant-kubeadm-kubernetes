#!/bin/bash
#
# Setup nfs server


set -euxo pipefail

CLUSTER_NETWORK_CIDR="10.0.0.1/24"
NODENAME=$(hostname -s)
SHARED_DIRECTORY="/data"


sudo apt-get update -y

# Install nfs server
sudo apt-get install -y nfs-kernel-server

# Make shared NFS directory
sudo mkdir -p $SHARED_DIRECTORY

# Set directory permissions
sudo chown -R $NODENAME:$NODENAME $SHARED_DIRECTORY

# Set file permissions
sudo chmod 777 $SHARED_DIRECTORY

cat >> /etc/exports << EOF
$SHARED_DIRECTORY $CLUSTER_NETWORK_CIDR(rw,sync,no_subtree_check)
EOF

# Restart NFS server
sudo systemctl restart nfs-kernel-server

# Grant Firewall access
sudo ufw allow from $CLUSTER_NETWORK_CIDR to any port nfs

