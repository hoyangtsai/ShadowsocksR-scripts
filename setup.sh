#!/bin/bash

setupEnv(){
  yum update -y
  yum install git jq -y
  cd ~/
  git clone https://github.com/shadowsocksr-backup/shadowsocksr.git
  cd ~/shadowsocksr
  git checkout -b manyuser origin/manyuser
  git clone https://github.com/hoyangtsai/shadowsocksr-scripts.git
}

editConfig() {
  JQR=""
  
  read -p "Enter password: " PASSWORD
  if [ $PASSWORD ]; then
    JQR=".password=\"$PASSWORD\""
  fi

  read -p "Enter a port number (0 - 65535): " PORT
  if [ $PORT ]; then
    JQR="$JQR | .server_port=$PORT"
  fi

  cat ~/shadowsocksr/shadowsocksr-scripts/user-config.json | jq "$JQR" > ~/shadowsocksr/user-config.json
    
  echo "Edit user-config.json done!!"
}

setupIPtables(){
  read -p "Enter the port number enabled: " PORT
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