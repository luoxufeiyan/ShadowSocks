#! /bin/bash
echo "Run this script as root!"
apt-get install -y python python-m2crypto supervisor wget git

# install python-pip
cd /tmp

# wget https://bootstrap.pypa.io/get-pip.py
# python get-pip.py

pip3 install git+https://github.com/luoxufeiyan/ShadowFlying.git@master


echo "config shadowsocks."
cat > /etc/shadowsocks.json<<-EOF
{
    "server":"0.0.0.0",
    "server_port":3389,
    "local_address":"127.0.0.1",
    "local_port":1081,
    "password":"MyDefaultPasswd",
    "timeout":600,
    "method":"aes-256-cfb"
}
EOF

sleep 1s
cat > /etc/supervisor/conf.d/shadowsocks.conf <<EOF
[program:shadowsocks]
command=/usr/local/bin/sslocal -c /etc/shadowsocks.json
autorestart=true
user=nobody
EOF

sleep 1s
invoke-rc.d supervisor restart
sleep 2s
supervisorctl status

echo "Shadowsocks successfully installed."
