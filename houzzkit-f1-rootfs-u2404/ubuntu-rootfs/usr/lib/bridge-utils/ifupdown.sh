#!/bin/sh

# You don't usually need to touch this file at all, the full configuration
# of the bridge can be done in a standard way on /etc/network/interfaces.

# Have a look at /usr/share/doc/bridge-utils/README.Debian if you want
# more info about the way on wich a bridge is set up on Debian.

if [ ! -x /sbin/brctl ]
then
  exit 0
fi

#default configuration
[ -f /etc/default/bridge-utils ] && . /etc/default/bridge-utils

. /lib/bridge-utils/bridge-utils.sh

case "$IF_BRIDGE_PORTS" in
    "")
	exit 0
	;;
    none)
	INTERFACES=""
	;;
    *)
	INTERFACES="$IF_BRIDGE_PORTS"
	;;
esac

# Overload bridge_hw, now it can be a device as well as an address
# The device can exist or not, then it is emptied
if [ "$IF_BRIDGE_HW" ] && ! echo "$IF_BRIDGE_HW"|grep -q "..:..:..:..:..:.."; then
  IF_BRIDGE_HW="$(ip link show dev "$IF_BRIDGE_HW" 2>/dev/null|sed -n "s|.*link/ether \([^ ]*\) brd.*|\1|p")"
fi
# Previous work (create the interface)
if [ "$MODE" = "start" ] && [ ! -d /sys/class/net/$IFACE ]; then
  brctl addbr $IFACE || exit 1
  if [ "$IF_BRIDGE_HW" ]; then
    sleep 1
    ip link set dev $IFACE address $IF_BRIDGE_HW
  fi
# Activate VLAN filtering on VLAN aware bridges                                
  if [ "$IF_BRIDGE_VLAN_AWARE" = "yes" ]; then                                 
    ip link set dev $IFACE type bridge vlan_filtering 1                        
  else                                                                         
    ip link set dev $IFACE type bridge vlan_filtering 0                        
  fi                                                                           
# Wait for the ports to become available
  if [ "$IF_BRIDGE_WAITPORT" ]
  then
    set x $IF_BRIDGE_WAITPORT &&   
    shift &&
    WAIT="$1" &&
    shift &&
    WAITPORT="$@" &&
    if [ -z "$WAITPORT" ];then WAITPORT="$IF_BRIDGE_PORTS";fi &&
    STARTTIME=$(date +%s) &&
    NOTFOUND="true" &&
    /bin/echo -e "\nWaiting for a max of $WAIT seconds for $WAITPORT to become available." &&
    while [ "$(($(date +%s)-$STARTTIME))" -le "$WAIT" ] && [ -n "$NOTFOUND" ]
    do
      NOTFOUND=""
      for i in $WAITPORT
      do
        if [ ! -e "/sys/class/net/$i" ];then NOTFOUND="true";fi
      done
      if [ -n "$NOTFOUND" ];then sleep 1;fi
    done
  fi
# Previous work (stop the interface)
elif [ "$MODE" = "stop" ];  then
  if [ "$PHASE" = "pre-down" ]; then
    [ ! -d /sys/class/net/$IFACE ] && brctl addbr $IFACE && ip address add "$IF_ADDRESS"/"$IF_NETMASK" dev $IFACE
  elif [ "$PHASE" = "post-down" ]; then
  ip link set dev $IFACE down || exit 1
  fi
fi

all_interfaces= &&
unset all_interfaces &&
bridge_parse_ports $INTERFACES | while read i
do
  for port in $i
  do
    # We attach and configure each port of the bridge
    if [ "$MODE" = "start" ] && [ ! -d /sys/class/net/$IFACE/brif/$port ]; then
      create_vlan_port
      if [ -e "/sys/class/net/$port" ]
      then
        if [ "$IF_BRIDGE_HW" ]
        then
          KVER="$(uname -r)"
          LKVER="${KVER#*.}"
          LKVER="${LKVER%%-*}"
          LKVER="${LKVER%%.*}"
          if [ "${KVER%%.*}" -lt 3 -o "${KVER%%.*}" -eq 3 -a "$LKVER" -lt 3 ]
          then
            ip link set dev $port address $IF_BRIDGE_HW
          fi
        fi
        if [ -e /proc/sys/net/ipv6/conf/$port ]
        then
          ip link set $port addrgenmode none
        fi
        if [ "$IF_MTU" ]
        then
          ip link set dev $port mtu "$IF_MTU"
        fi
        brctl addif $IFACE $port && ip link set dev $port up
      fi
    # We detach each port of the bridge
    elif [ "$MODE" = "stop" -a "$PHASE" = "post-down" ] && [ -d /sys/class/net/$IFACE/brif/$port ];  then
      ip link set dev $port down && brctl delif $IFACE $port && destroy_vlan_port
    fi
  done
done

# We finish setting up the bridge
if [ "$MODE" = "start" ] ; then

  if [ "$IF_BRIDGE_AGEING" ]
  then
    brctl setageing $IFACE $IF_BRIDGE_AGEING
  fi

  if [ "$IF_BRIDGE_BRIDGEPRIO" ]
  then
    brctl setbridgeprio $IFACE $IF_BRIDGE_BRIDGEPRIO
  fi

  if [ "$IF_BRIDGE_GCINT" ]
  then
    brctl setgcint $IFACE $IF_BRIDGE_GCINT
  fi

  if [ "$IF_BRIDGE_HELLO" ]
  then
    brctl sethello $IFACE $IF_BRIDGE_HELLO
  fi

  if [ "$IF_BRIDGE_MAXAGE" ]
  then
    brctl setmaxage $IFACE $IF_BRIDGE_MAXAGE
  fi

  if [ "$IF_BRIDGE_PATHCOST" ]
  then
    echo "$IF_BRIDGE_PATHCOST" | {
      while read PORT COST; do
        brctl setpathcost $IFACE $PORT $COST
      done
    }
  fi

  if [ "$IF_BRIDGE_PORTPRIO" ]
  then
    echo "$IF_BRIDGE_PORTPRIO" | {
      while read PORT PRIO; do
        brctl setportprio $IFACE $PORT $PRIO
      done
    }
  fi

  if [ "$IF_BRIDGE_STP" ]
  then
    brctl stp $IFACE $IF_BRIDGE_STP
  fi

  if [ "$IF_BRIDGE_FD" ]
  then
    brctl setfd $IFACE $IF_BRIDGE_FD
  fi


  # We activate the bridge
  ip link set dev $IFACE up


  # Calculate the maximum time to wait for the bridge to be ready
  if [ "$IF_BRIDGE_MAXWAIT" ]
  then
    MAXWAIT=$IF_BRIDGE_MAXWAIT
  else
    MAXWAIT=$(brctl showstp $IFACE 2>/dev/null|sed -n 's/^.*forward delay[ \t]*\(.*\)\..*bridge forward delay[ \t]*\(.*\)\..*$/\1 \2/p')
    if [ "$MAXWAIT" ]
    then
      if [ ${MAXWAIT% *} -gt ${MAXWAIT#* } ]
      then
        MAXWAIT=$((2*(${MAXWAIT% *}+1)))
      else
        MAXWAIT=$((2*(${MAXWAIT#* }+1)))
      fi
    else
      if [ "$IF_BRIDGE_FD" ]
      then
        MAXWAIT=$((2*(${IF_BRIDGE_FD%.*}+1)))
      else
        MAXWAIT=32
      fi
      /bin/echo -e "\nWaiting $MAXWAIT seconds for $IFACE to get ready."
      sleep $MAXWAIT
      MAXWAIT=0
    fi
  fi


  # Wait for the bridge to be ready
  if [ "$MAXWAIT" != 0 ]
  then
    unset BREADY
    unset TRANSITIONED
    COUNT=0
    MMAXWAIT=$MAXWAIT

    # Use 0.1 delay if available
    sleep 0.1 2>/dev/null && MMAXWAIT=$((MAXWAIT * 10))

    while [ ! "$BREADY" -a $COUNT -lt $MMAXWAIT ]
    do
      sleep 0.1 2>/dev/null || sleep 1
      COUNT=$(($COUNT+1))
      BREADY=true
      for i in $(brctl showstp $IFACE|sed -n 's/^.*port id.*state[ \t]*\(.*\)$/\1/p')
      do
        if [ "$i" = "listening" -o "$i" = "learning" -o "$i" = "forwarding" -o "$i" = "blocking" ]
        then
          TRANSITIONED=true
        fi
        if [ "$i" != "forwarding" -a "$i" != "blocking" ] && [ ! "$TRANSITIONED" -o "$i" != "disabled" ]
        then
          unset BREADY
        fi
      done
      if [ ! "$BREADY" -a $COUNT = 2 ]
      then
        /bin/echo -e "\nWaiting for $IFACE to get ready (MAXWAIT is $MAXWAIT seconds)."
      fi
    done
  fi

# Finally we destroy the interface
elif [ "$MODE" = "stop" -a "$PHASE" = "post-down" ];  then

  brctl delbr $IFACE

fi
