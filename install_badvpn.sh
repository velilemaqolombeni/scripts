#!/bin/sh
apt update;apt -y install cmake make gcc bzip2 binutils build-essential

wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/badvpn/badvpn-1.999.128.tar.bz2

tar xf badvpn-1.999.128.tar.bz2

mkdir badvpn-build

cd badvpn-build

cmake ~/badvpn-1.999.128 -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1

make install

badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500 --max-connections-for-client 20 &

cd

sleep 2

cat > /etc/rc.local <<END
#!/bin/sh
badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500 --max-connections-for-client 20 &
END
chmod +x /etc/rc.local

cat > /etc/systemd/system/rc-local.service <<EOL
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=oneshot
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOL

chmod +x /etc/systemd/system/rc-local.service

systemctl enable rc-local
#systemctl start rc-local.service
systemctl status rc-local.service
