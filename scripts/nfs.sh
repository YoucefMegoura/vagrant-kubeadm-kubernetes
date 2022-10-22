#!/bin/bash
#
# Setup nfs server


set -euxo pipefail

CLUSTER_NETWORK_CIDR="10.0.0.1/24"
NODENAME=$(hostname -s)


sudo apt-get update -y

# Install nfs server
sudo apt-get install -y nfs-kernel-server

# Make shared NFS directory
sudo mkdir -p /data

# Set directory permissions
sudo chown -R vagrant:vagrant /data

# Set file permissions
sudo chmod 777 /data

cat >> /etc/exports << EOF
/data $CLUSTER_NETWORK_CIDR(rw,sync,no_subtree_check)
EOF

# Restart NFS server
sudo systemctl restart nfs-kernel-server

# Grant Firewall access
sudo ufw allow from $CLUSTER_NETWORK_CIDR to any port nfs

