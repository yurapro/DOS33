#!/bin/bash

ISO_PATH="C:/Users/YuraP/source/files/ubuntu-24.04.3-live-server-amd64.iso"
VM_DIR="$HOME/VirtualBox VMs"
VM_USER="user"
VM_PASS="password"

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    ssh-keygen -t rsa -b 2048 -f "$HOME/.ssh/id_rsa" -N ""
fi

for i in {1..3}; do
    VM_NAME="ubuntu-node-$i"
    echo "Creating BM: $VM_NAME"

    VBoxManage createvm --name "$VM_NAME" --ostype "Ubuntu_64" --register --basefolder "$VM_DIR"
    
    VBoxManage modifyvm "$VM_NAME" --memory 2048 --cpus 2 --nic1 nat --boot1 dvd

    VBoxManage createhd --filename "$VM_DIR/$VM_NAME/$VM_NAME.vdi" --size 20000
    VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
    VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_DIR/$VM_NAME/$VM_NAME.vdi"

    VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide
    VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"

    SSH_PORT=$((2200 + i))
    VBoxManage modifyvm "$VM_NAME" --natpf1 "ssh,tcp,,$SSH_PORT,,22"

    VBoxManage startvm "$VM_NAME" --type headless
done

echo "Machines is created: ssh -p <port> $VM_USER@localhost"
