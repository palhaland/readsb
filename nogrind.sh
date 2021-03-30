#!/bin/bash
systemctl stop test
rm -rf /run/test
mkdir -p /run/test
chown readsb /run/test
source /etc/default/test
cp -f readsb /tmp/test123

#gdb -ex=run --args /tmp/test123 --quiet $RECEIVER_OPTIONS $DECODER_OPTIONS $NET_OPTIONS $JSON_OPTIONS --write-json /run/test $@
sudo -u readsb /tmp/test123 --quiet $RECEIVER_OPTIONS $DECODER_OPTIONS $NET_OPTIONS $JSON_OPTIONS --write-json /run/test $@
#sudo -u readsb ./readsb --quiet $RECEIVER_OPTIONS $DECODER_OPTIONS $NET_OPTIONS $JSON_OPTIONS --write-json /run/test --net-connector 127.0.0.1,50006,beast_in $@

