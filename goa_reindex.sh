# masternode
#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will reindex GOA Coin masternodes.                           *"
echo "****************************************************************************"
echo && echo && echo

##############
# Linux VPS
# SSH into your Linux VPS 
# Login as root


# Now change directory to the goacoin source folder
cd goacoin/src

# Now on Windows go to this URL:
# http://goacoin.be/
# Look at latest Block number under the Latest Transactions list

# Now back on Linux 
# run this command
./goacoin-cli getmininginfo
#look at "blocks":  Should be the same as the website, if not we need to reindex

# In my case the blocks on my Linux were lower than the web site so I need to reindex

# Stop goacoin from running in the background
./goacoin-cli stop

# Reindex
goacoind -daemon -reindex

# Now keep running this command every few seconds looking at "blocks":  
./goacoin-cli getmininginfo
# Should be going up in number to match web site

# Once your Linux VPS Blocks matches http://goacoin.be/ Blocks
# Reindex Windwos
##############
# Windows Machine
## Now open your Windows wallet
## Click on the menu option "Tools" --> "Wallet Repair"
##  On the Wallet Repair Tab 
##   Click on the "Rebuild Index" button at the bottom of the screen

## Wait for the reindex to complete
## Close the Tools Window
## Click on MasterNodes button
## Right Click on your Masternode that is showing "New_Start_Required"
## Click on "Start alias"
##  Click "Yes" on the pop-up asing you "Are you sure ..."
##   Enter your wallet password 

## You should get a pop-up that says "Successfully started masternode."
##  Your MN status should now say "PRE_ENABLED"

##  Wait about 30 minutes or more
##  Your MN status should change to "ENABLED" automatically

## Profit!!!

