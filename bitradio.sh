# masternode
#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your Bitrad.io masternodes.      *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then
  apt-get update
  apt-get -y upgrade
  apt-get -y dist-upgrade
  apt-get install -y nano htop git
  apt-get install -y software-properties-common
  apt-get install -y build-essential libtool autotools-dev pkg-config libssl-dev
  apt-get install -y libboost-all-dev
  apt-get install -y libevent-dev
  apt-get install -y libminiupnpc-dev
  apt-get install -y autoconf
  apt-get install -y automake unzip
  add-apt-repository  -y  ppa:bitcoin/bitcoin
  apt-get update
  apt-get install -y libdb4.8-dev libdb4.8++-dev
  apt-get install -y libgmp3-dev

  cd /var
  touch swap.img
  chmod 600 swap.img
  dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
  mkswap /var/swap.img
  swapon /var/swap.img
  free
  echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd

  apt-get install -y ufw
  ufw allow ssh/tcp
  ufw limit ssh/tcp
  ufw logging on
  echo "y" | sudo ufw enable
  ufw allow 32454
  ufw allow 32455
  iptables -t filter -A INPUT -i eth0 -p tcp --dport 32454 -j ACCEPT
  iptables -t filter -A INPUT -i eth0 -p tcp --dport 32455 -j ACCEPT
  ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi
git clone https://github.com/thebitradio/Bitradio
cd Bitradio/src
make -f makefile.unix # Headless
strip Bitradiod
cp Bitradiod /usr/local/bin

echo ""
echo "Configure your masternodes now!"
echo "Type the IP of this server, followed by [ENTER]:"
read IP

echo ""
echo "Enter masternode private key for node $ALIAS"
read PRIVKEY

CONF_DIR=~/.Bitradio/
CONF_FILE=Bitradio.conf
PORT=32454

mkdir -p $CONF_DIR
echo "rpcuser=Bitradiorpc" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "" >> $CONF_DIR/$CONF_FILE
echo "" >> $CONF_DIR/$CONF_FILE
echo "externalip=$IP" >> $CONF_DIR/$CONF_FILE
echo "port=$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeaddr=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE
sudo ufw allow $PORT/tcp

Bitradiod -daemon 
Bitradiod masternode status


