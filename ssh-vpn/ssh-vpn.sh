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
    ssh -NCTvvv -E /root/log -w $TUNDEV:$TUNDEV root@$REMOTEHOST
}

setup_local_interfaces()
{
    if [ "$SYS" == "FreeBSD" ];
    then
	ifconfig tun$TUNDEV up
	ifconfig tun$TUNDEV $LOCALIP/$CIDR $REMOTEIP
    else
	ip link set dev tun$TUNDEV up
	ip addr add $LOCALIP/$CIDR remote $REMOTEIP/$CIDR dev tun$TUNDEV
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
	ssh root@$REMOTEHOST ip addr add $REMOTEIP/$CIDR remote $LOCALIP/$CIDR dev tun$TUNDEV
    fi
}

destroy_local_interfaces()
{
    if [ "$SYS" == "FreeBSD" ];
    then
	ifconfig tun$TUNDEV destroy
    fi
}

destroy_remote_interfaces()
{
    if [ "$RSYS" == "FreeBSD" ];
    then
	ssh root@$REMOTEHOST ifconfig tun$TUNDEV destroy
    fi
}

if [ "$1" == "" ];
then
    echo "Invalid options." >&2
    exit 255
fi

while getopts "rsk" opt; do
    case "$opt" in
	r)
	    start_ssh
	    ;;
    
	s)
	    setup_local_interfaces
	    setup_remote_interfaces
	    ;;
    
	k)
	    destroy_local_interfaces
	    destroy_remote_interfaces
	    ;;
    esac
done
