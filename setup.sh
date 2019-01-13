#!/bin/bash

setupEnv(){
  yum update -y
  yum install git jq -y
  cd ~/
  git clone https://github.com/shadowsocksr-backup/shadowsocksr.git
  cd shadowsocksr/
  git checkout -b manyuser origin/manyuser
  git clone https://github.com/hoyangtsai/ShadowsocksR-scripts.git
}

editConfig() {
  JQR=""
  
  echo "What's the password?"
  read PASSWORD
  if [ $PASSWORD ]; then
    JQR=".password=\"$PASSWORD\""
  fi

  # echo "What's the server port?"
  # read PORT
  # if [ $PORT ]; then
  #   JQR="$JQR | .server_port=$PORT"
  # fi

  cat user-config.json | jq "$JQR" \
    > file.tmp.json && cp file.tmp.json user-config.json && rm file.tmp.json
    
  echo "Edit user-config.json done!!"
}

setupIPtables(){
  echo "Which port is enabled?"
  read PORT
  iptables -I INPUT -p tcp --dport $PORT -j ACCEPT
  iptables -I INPUT -p udp --dport $PORT -j ACCEPT
  /etc/rc.d/init.d/iptables save
  /etc/init.d/iptables restart

  echo "Edit iptables done!!"
}

setupBBR(){
  wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
  chmod a+x bbr.sh
  ./bbr.sh
}

setupEnv
editConfig
setupIPtables
setupBBR

echo "Setup completed!!"