# masternode
#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your GOA Coin masternodes.      *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

free -h
#that will just show what you currenty have

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then

touch /var/swap.img
dd if=/dev/zero of=/var/swap.img bs=1M count=1024
sudo chmod 0600 /var/swap.img
sudo chown root:root /var/swap.img
sudo nano /etc/fstab
/var/swap.img none swap sw 0 0

  
sudo apt-get install -y nano htop git
sudo apt-get update
sudo apt-get install automake
sudo apt-get install libdb++-dev
sudo apt-get install build-essential libtool autotools-dev
sudo apt-get install autoconf pkg-config libssl-dev
sudo apt-get install libboost-all-dev
sudo apt-get install libminiupnpc-dev
sudo apt-get install git
Sudo apt-get install libevent-dev
sudo apt-get install software-properties-common
sudo apt-get install python-software-properties
sudo apt-get install g++
sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt-get install libboost-all-dev
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install libdb4.8-dev libdb4.8++-dev


   sudo apt-get install -y ufw
 sudo ufw allow OpenSSH
sudo ufw allow 1945
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

cd ~
git clone https://github.com/ivansib/sibcoin.git
cd ~/sibcoin/
./autogen.sh
./configure
make
sudo make install

sibcoind &





echo ""
echo "Configure your masternodes now!"
echo "Type the IP of this server, followed by [ENTER]:"
read IP

echo ""
echo "Enter masternode private key for node $ALIAS"
read PRIVKEY

CONF_DIR=~/.sibcoin/
CONF_FILE=sibcoin.conf
PORT=1945

rpcuser=<username, anything works>
rpcpassword=<password, letters, numbers okay>
masternode=1
daemon=1
listen=1
server=1
masternodeprivkey=<priv key from step 6>
externalip=<your external IP address>:1945



mkdir -p $CONF_DIR
echo "rpcuser=goacoin" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=1qa2ws3ed4r" >> $CONF_DIR/$CONF_FILE
echo "rpcport=10024" >> $CONF_DIR/$CONF_FILE
echo "port=$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE

echo "" >> $CONF_DIR/$CONF_FILE
echo "externalip=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE

sibcoind &
