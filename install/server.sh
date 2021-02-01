#!/bin/bash

echo "Please run this script as root"

apt-get install -y python3 python3-pip python-m2crypto supervisor wget git build-essential

#mkdir /tmp
cd /tmp

#wget https://bootstrap.pypa.io/get-pip.py
#python get-pip.py
pip3 install git+https://github.com/luoxufeiyan/ShadowFlying.git@master


# upgrade libsodium
wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar zxf LATEST.tar.gz
cd libsodium*
./configure
make && make install
ldconfig

# config file
mkdir -p /etc/shadowsocks/
cat > /etc/shadowsocks/shadowsocks.json <<EOF

{
        "server":"0.0.0.0",
        "server_port":3389,
        "password":"password",
        "timeout":300,
        "method":"xchacha20-ietf-poly1305",
        "fast_open":true
}
EOF

sleep 1s
mkdir /var/log/supervisor/
cat > /etc/supervisor/conf.d/shadowsocks.conf <<EOF

[program:shadowsocks]
command=/usr/local/bin/ssserver -c /etc/shadowsocks/shadowsocks.json
autorestart=true
user=nobody
redirect_stderr = true 
stdout_logfile_maxbytes = 10MB 
stdout_logfile_backups = 20    
stdout_logfile = /var/log/supervisor/shadowsocks_stdout.log
EOF


sleep 5s
supervisorctl reread
sleep 5s
supervisorctl update
sleep 5s

supervisorctl status
