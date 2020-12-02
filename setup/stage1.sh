#!/bin/bash
OSPART="TOBEFILLED"
EFIPART="TOBEFILLED"
SWAPPART="TOBEFILLED"
if [ "$OSPART" = "TOBEFILLED" ] || [ "$EFIPART" = "TOBEFILLED" ] || [ "$SWAPPART" = "TOBEFILLED" ]; then
    echo "Please edit stage1.sh and add the OS, EFI and SWAP partitions"
    exit
fi

echo "Making $OSPART ext4" && sleep 0.5
mkfs.ext4 $OSPART
echo "Making $EFIPART fat32" && sleep 0.5
mkfs.fat -F32 $EFIPART
echo "Making $SWAPPART swap" && sleep 0.5
mkswap $SWAPPART
echo "Making /mnt directory and mounting $OSPART on it" && sleep 0.5
mkdir /mnt
mount $OSPART /mnt
echo "Making /mnt/efi directory and mounting $EFIPART on it" && sleep 0.5
mkdir /mnt/efi
mount $EFIPART /mnt/efi
echo "Swap on for $SWAPPART" && sleep 0.5
swapon $SWAPPART

echo "Pacstrapping" && sleep 0.5
pacstrap /mnt/ base base-devel linux linux-firmware
echo "Genfstabbing" && sleep 0.5
genfstab -U /mnt/ >> /mnt/etc/fstab
echo "Copying setup files to the disk" && sleep 0.5
cp -r ../setup /mnt/setup
echo "STRAP IN!" && sleep 0.5
arch-chroot /mnt/
