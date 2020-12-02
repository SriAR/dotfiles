#!/bin/bash
OSPART="TOBEFILLED"
EFIPART="TOBEFILLED"
if [ "$OSPART" = "TOBEFILLED" ] || [ "$EFIPART" = "TOBEFILLED" ]; then
    echo "Please edit stage1.sh and add the OS and BOOT partitions"
    exit
fi

mkfs.ext4 $OSPART
#mkfs.fat -F32 $BOOTPART
mount $OSPART /mnt
mkdir /mnt/efi
mount $EFIPART /mnt/efi

pacstrap /mnt/ base base-devel linux linux-firmware
genfstab -U /mnt/ >> /mnt/etc/fstab
cp -r ../setup /mnt/setup
arch-chroot /mnt/
