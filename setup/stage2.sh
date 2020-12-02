echo "Setting clock time to Calcutta" && sleep 0.5
ln -sf /usr/share/zoneinfo/Asia/Calcutta /etc/localtime
hwclock --systohc

echo "Locale-gen and so on" && sleep 0.5
sed "s/^#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

HOST="cs"
echo "Setting hostname to $HOST" && sleep 0.5
echo "$HOST" > /etc/hostname
cat <<EOF > /etc/hosts
# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1	localhost
::1		localhost
127.0.1.1	$HOST.localdomain	$HOST
EOF

echo "Root Password?" && sleep 0.5
passwd
echo "cs Password?" && sleep 0.5
useradd -m -G users -s /bin/bash cs
passwd cs
echo "Installing microcode."
pacman -S intel-ucode git vi
EDITOR=vi visudo
su - cs
