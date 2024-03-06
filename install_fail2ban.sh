#!/bin/sh
apt update;apt -y install fail2ban screen sudo
sleep 2
systemctl enable fail2ban.service

cat > /etc/fail2ban/jail.local <<EOL
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = -1
ignoreip = 127.0.0.1
EOL

sleep 2
systemctl restart fail2ban.service
sleep 2
systemctl status fail2ban.service
sleep 2

fail2ban-client status
sleep 2
fail2ban-client status sshd
