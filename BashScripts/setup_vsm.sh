#!/bin/bash

VM_IPS=("192.168.56.101" "192.168.56.102" "192.168.56.103")
SSH_USER="your_username"
SSH_KEY="/path/to/your/private_key"

echo "Setting up a ВМ: Updating Packages and SSH..."

for IP in "${VM_IPS[@]}"; do
    echo "I work with с ВМ over IP: $IP"
    
    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$SSH_USER@$IP" "
        sudo apt update && sudo apt upgrade -y
    "
    
    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$SSH_USER@$IP" "
        sudo systemctl is-active --quiet ssh || sudo systemctl start ssh
        sudo systemctl enable ssh
    "

    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$SSH_USER@$IP" "
        lsb_release -a
    "
    
    echo "ВМ $IP configured."
done

echo "All ВМ configured."