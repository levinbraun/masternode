#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your Omega Coin masternodes.      *"
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
  echo "y" |   ufw enable
    ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

wget https://github.com/omegacoinnetwork/omegacoin/releases/download/0.12.5/omegacoincore-0.12.5-linux64.tar.gz
tar -xzf omegacoincore*.tar.gz
  mv  omegacoincore*/bin/* /usr/bin

echo ""
echo "Configure your masternodes now!"
echo "Type the IP of this server, followed by [ENTER]:"
read IP

echo ""
echo "Enter masternode private key for node $ALIAS"
read PRIVKEY

CONF_DIR=~/.omegacoincore/
CONF_FILE=omegacoin.conf
PORT=7777

mkdir -p $CONF_DIR
echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "" >> $CONF_DIR/$CONF_FILE

echo "addnode=142.208.127.121" >> $CONF_DIR/$CONF_FILE
echo "addnode=154.208.127.121" >> $CONF_DIR/$CONF_FILE
echo "addnode=142.208.122.127" >> $CONF_DIR/$CONF_FILE

echo "" >> $CONF_DIR/$CONF_FILE
echo "port=$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeaddr=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE
  ufw allow $PORT/tcp

omegacoind -daemon
