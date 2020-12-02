#!/bin/bash
OSPART="TOBEFILLED"
EFIPART="TOBEFILLED"
SWAPPART="TOBEFILLED"
if [ "$OSPART" = "TOBEFILLED" ] || [ "$EFIPART" = "TOBEFILLED" ] || [ "$SWAPPART" = "TOBEFILLED" ]; then
    echo "Please edit stage1.sh and add the OS, EFI and SWAP partitions"
    exit
fi

mkfs.ext4 $OSPART
mkfs.fat -F32 $BOOTPART
mkswap $SWAPPART
mkdir /mnt/efi
mount $OSPART /mnt
mount $EFIPART /mnt/efi
swapon $SWAPPART

pacstrap /mnt/ base base-devel linux linux-firmware
genfstab -U /mnt/ >> /mnt/etc/fstab
cp -r ../setup /mnt/setup
arch-chroot /mnt/
