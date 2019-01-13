#!/bin/bash

setupEnv(){
  yum update -y
  yum install git jq -y
  cd ~/
  git clone https://github.com/shadowsocksr-backup/shadowsocksr.git
  cd shadowsocksr/
  git checkout -b manyuser origin/manyuser
  wget --no-check-certificate https://gist.githubusercontent.com/hoyangtsai/7eaf805a80d82a2242882b1f28c06fb1/raw/31227dcc90a20149d3e1a1324cfa07a101bd6bac/user-config.json
  wget --no-check-certificate https://gist.githubusercontent.com/hoyangtsai/7d5eae25328984363eacaf743309ee5c/raw/1acf65452678ef6473a36db86cbbedba2e53cb04/config.sh
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