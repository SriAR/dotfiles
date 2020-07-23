ln -sf /usr/share/zoneinfo/Asia/Calcutta /etc/localtime
hwclock --systohc

HOST="homepc"
sed "s/^#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "$HOST" > /etc/hostname
cat <<EOF > /etc/hosts
# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1	localhost
::1		localhost
127.0.1.1	$HOST.localdomain	$HOST
EOF

passwd
useradd -m -G users -s /bin/bash cs
passwd cs
pacman -S intel-ucode
su - cs

