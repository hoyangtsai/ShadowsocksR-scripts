#!/bin/bash

setupEnv(){
  yum update -y
  yum install git jq -y
  cd ~/
  git clone https://github.com/shadowsocksr-backup/shadowsocksr.git
  cd shadowsocksr/
  git checkout -b manyuser origin/manyuser
  wget --no-check-certificate https://raw.githubusercontent.com/hoyangtsai/ShadowsocksR-scripts/master/user-config.json
  wget --no-check-certificate https://raw.githubusercontent.com/hoyangtsai/ShadowsocksR-scripts/master/config.sh
  chmod a+x config.sh
}

setupiptables(){
  echo "Which port is enabled?"
  read PORT
  iptables -I INPUT -p tcp --dport $PORT -j ACCEPT
  iptables -I INPUT -p udp --dport $PORT -j ACCEPT
  /etc/rc.d/init.d/iptables save
  /etc/init.d/iptables restart
}

setupBBR(){
  wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
  chmod a+x bbr.sh
  ./bbr.sh
}

setupEnv
setupiptables
setupBBR

echo "Setup completed!!"