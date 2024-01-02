# Windows

## How to generate a new autoattend.iso
Run `mkisofs -o autounattend.iso -J -R autounattend.xml` to create a new version of the ISO file.

The command creates an ISO file named autounattend.iso that contains the autounattend.xml file, ensuring the ISO is readable in both Windows (thanks to the `-J` Joliet extension) and Unix/Linux systems (thanks to the `-R` Rock Ridge extension). You would then upload this ISO to Proxmox and attach it to your virtual machine for Windows installation.

## How to get virtio-win.iso
Download virtio-win.iso from https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/?C=M;O=D

# Setup
https://pve.proxmox.com/wiki/Windows_2022_guest_best_practices

## Installation
* Mount virtio-win.iso (ide0), the Windows ISO (ide1), and autounattend.iso (ide2) as IDE devices to the VM
* Move Windows ISO to the top in Options -> Boot Order
* Go
