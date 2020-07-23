cat <<EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin cs --noclear %I $TERM
EOF
git clone https://aur.archlinux.org/pikaur.git
cd pikaur
makepkg -fsri
