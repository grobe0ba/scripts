#!/bin/sh


#Configuration Items

TUNDEV=

REMOTEHOST=

LOCALIP=
REMOTEIP=
CIDR=

SYS="$(uname -o)"
RSYS="$(ssh $REMOTEHOST uname -o)"

start_ssh()
{
    ssh -NCTf -w $TUNDEV:$TUNDEV root@$REMOTEHOST
    export PID=$!
}

setup_local_interfaces()
{
    if [ "$SYS" == "FreeBSD" ];
    then
	ifconfig tun$TUNDEV up
	ifconfig tun$TUNDEV $LOCALIP/$CIDR $REMOTEIP
    else
	ip link set dev tun$TUNDEV up
	ip addr add $LOCALIP/$CIDR remote $REMOTEIP dev tun$TUNDEV
    fi
}

setup_remote_interfaces()
{
    if [ "$RSYS" == "FreeBSD" ];
    then
	ssh root@$REMOTEHOST ifconfig tun$TUNDEV up
	ssh root@$REMOTEHOST ifconfig tun$TUNDEV $REMOTEIP/$CIDR $LOCALIP
    else
	ssh root@$REMOTEHOST ip link set dev tun$TUNDEV up
	ssh root@$REMOTEHOST ip addr add $REMOTEIP/$CIDR remote $LOCALIP dev tun$TUNDEV
    fi
}

destroy_local_interfaces()
{
    if [ "$SYS" == "FreeBSD" ];
    then
	ssh root@$REMOTEHOST ifconfig tun$TUNDEV destroy
    fi
}

destroy_remote_interfaces()
{
    if [ "$RSYS" == "FreeBSD" ];
    then
	ssh root@$REMOTEHOST ifconfig tun$TUNDEV destroy
    fi
}


start_ssh
setup_local_interfaces
setup_remote_interfaces

while true;
do
    if ! kill -1 $PID;
    then
	destroy_local_interfaces
	destroy_remote_interfaces
	start_ssh
	setup_local_interfaces
	setup_remote_interfaces
    fi
    sleep 5;
done

