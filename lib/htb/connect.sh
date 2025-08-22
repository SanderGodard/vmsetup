#!/usr/bin/bash

if [ -f "$1" ]; then
# http://help.hackthebox.com/en/articles/9297532-connecting-to-academy-vpn#h_da8bb65b12
#	sudo sed -i 's/udp/tcp/g; s/1337/443/g; s/tls-auth/tls-crypt/g' /etc/openvpn/*.conf
#	sudo systemctl restart openvpn

	sudo killall openvpn
	sudo openvpn "$1"
else
	echo -e "usage: $0 [filename.ovpn]"
fi

