#!/bin/bash

SSH_KEY_DIR="$HOME/.ssh"
SSH_KEY_FILE="$SSH_KEY_DIR/id_rsa"

if [ ! -f "$SSH_KEY_FILE" ]; then
    echo "SSH‑key not found. I'm creating a new one..."
    
    mkdir -p "$SSH_KEY_DIR"
    chmod 700 "$SSH_KEY_DIR"
    
    ssh-keygen -t rsa -b 2048 -f "$SSH_KEY_FILE" -N ""
    
    echo "SSH‑key created: $SSH_KEY_FILE"
else
    echo "SSH‑ключ уже существует: $SSH_KEY_FILE"
fi

VM_PREFIX="vm-lab"
VM_COUNT=3
RAM=2048
CPUS=2
HDD_SIZE=10240
ISO_PATH="C:/Users/YuraP/source/files/ubuntu-24.04.3-live-server-amd64.iso"
NETWORK="BRIGED"

echo "Creating $VM_COUNT Virtual machines..."

for i in $(seq 1 $VM_COUNT); do
    VM_NAME="${VM_PREFIX}-${i}"
    
    echo "Precess creting ВМ: $VM_NAME"
    
    VBoxManage createvm --name "$VM_NAME" --register
    
    VBoxManage modifyvm "$VM_NAME" \
        --memory $RAM \
        --cpus $CPUS \
        --boot1 dvd \
        --boot2 hd \
        --nic1 $NETWORK \
        --ostype Ubuntu_64

    VBoxManage createhd --filename "$VM_NAME.vdi" --size $HDD_SIZE
    
    VBoxManage storagectl "$VM_NAME" --name "SATA" --add sata --controller IntelAhci
    VBoxManage storageattach "$VM_NAME" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "$VM_NAME.vdi"
    
    VBoxManage storageattach "$VM_NAME" --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"
    
    echo "ВМ $VM_NAME Creted."
done

echo "All ВМ Creating. now install ОС for each (Start the ВМ via the GUI or VBoxManage startvm)."