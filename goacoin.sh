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

#now setup the swap:
sudo fallocate -l 4G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
#Make Changes Permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo bash -c "echo 'vm.swappiness = 10' >> /etc/sysctl.conf"

#Confirm Changes, you should now see a second line different that before, showing the 4G swap has been setup
free -h

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then
  sudo apt-get update
  sudo apt-get -y upgrade
  sudo apt-get -y dist-upgrade
  sudo apt-get install -y nano htop git
  sudo apt-get install -y software-properties-common
  sudo apt-get install -y build-essential libtool autotools-dev pkg-config libssl-dev
  sudo apt-get install -y libboost-all-dev
  sudo apt-get install -y libevent-dev
  sudo apt-get install -y libminiupnpc-dev
  sudo apt-get install -y autoconf
  sudo apt-get install -y automake unzip
  sudo add-apt-repository  -y  ppa:bitcoin/bitcoin
  sudo apt-get update
  sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd

  sudo apt-get install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw allow 1947/tcp
  sudo ufw allow 10024/tcp
  sudo iptables -t filter -A INPUT -i eth0 -p tcp --dport 1947 -j ACCEPT
  sudo iptables -t filter -A INPUT -i eth0 -p tcp --dport 1948 -j ACCEPT
  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

#wget https://github.com/goacoincore/goacoin/releases/download/v0.12.1.9/goacoin-daemon-0.12.1.9-linux64.tar.gz
#tar -xzf goacoin-daemon-*.tar.gz
#cd .goacoincore
#sudo mv goacoind /usr/bin
#sudo mv goacoin-cli /usr/bin

git clone https://github.com/goacoincore/goacoin.git
cd goacoin
chmod 755 autogen.sh 
./autogen.sh
./configure
chmod 755 share/genbuild.sh
make
chmod +x goacoin/src/goacoind
cp goacoin/src/goacoind /usr/local/bin/
cp goacoin/src/goacoin-cli /usr/local/bin/

echo ""
echo "Configure your masternodes now!"
echo "Type the IP of this server, followed by [ENTER]:"
read IP

echo ""
echo "Enter masternode private key for node $ALIAS"
read PRIVKEY

CONF_DIR=~/.goacoincore/
CONF_FILE=goacoin.conf
PORT=1947

mkdir -p $CONF_DIR
echo "rpcuser=goacoin" >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=1qa2ws3ed4r" >> $CONF_DIR/$CONF_FILE
echo "rpcport=10024" >> $CONF_DIR/$CONF_FILE
echo "port=$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "staking=0" >> $CONF_DIR/$CONF_FILE
echo "discover=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE

echo "" >> $CONF_DIR/$CONF_FILE
echo "externalip=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE

sudo goacoind -daemon
