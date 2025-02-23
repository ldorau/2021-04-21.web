#!/usr/bin/env bash
# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2020-2021, Intel Corporation

#
# config_softroce.sh - configure SoftRoCE
#
# This script configures a software-emulated RDMA network interface (SoftRoCE),
# which requires:
# - one machine with a regular Ethernet network adapter,
# - the libibverbs and librdmacm libraries (or the rdma-core package
#   containing both of them) installed,
# - the 'rdma_rxe' kernel module loaded.
#
# Usage: config_softroce.sh [<network_interface>]
#
# Options:
# <network_interface> - configure SoftRoCE for the given <network_interface>
#                       or for the first active and up one if no argument
#                       is given
#

NET_IF=$1

MODULE="rdma_rxe"
DIR="/lib/modules/$(uname -r)"
STATE_OK="state ACTIVE physical_state LINK_UP"

function get_IP4() {
	NET_IF=$1
	ip -4 -j -p a show $NET_IF | grep -e local | cut -d'"' -f4
}

function print_IP4_of() {
	NET_IF=$1
	IP=$(get_IP4 $NET_IF)
	if [ "$IP" != "" ]; then
		echo -n "$IP"
	else
		echo "no IP address assigned"
		exit 1
	fi
}

function print_IP4_all() {
	NET_IFS=$(rdma link show | grep -e "$STATE_OK" | cut -d' ' -f8)
	for NET_IF in $NET_IFS; do
		IP=$(get_IP4 $NET_IF)
		[ "$IP" != "" ] && echo -n "$IP"
	done
}

if [ $(lsmod | grep -e $MODULE | wc -l) -lt 1 ]; then
	N_MODULES=$(find $DIR -name "$MODULE.ko*" | wc -l)
	if [ $N_MODULES -lt 1 ]; then
		echo "Error: cannot find the '$MODULE' module in the '$DIR' directory"
		exit 1
	fi

	if ! sudo modprobe $MODULE; then
		echo "Error: cannot load the '$MODULE' module"
		sudo modprobe -v $MODULE
		exit 1
	fi
fi

if ! which ip > /dev/null; then
	echo "Error: cannot find the 'ip' command. Install the 'iproute/iproute2' package"
	exit 1
fi

if ! which rdma > /dev/null; then
	echo "Error: cannot find the 'rdma' command. Install the 'iproute/iproute2' package"
	exit 1
fi

if ! rdma link show > /dev/null ; then
	echo "Error: the 'rdma link show' command failed"
	exit 1
fi

if [ "$NET_IF" == "" ]; then
	RDMA_LINKS=$(rdma link show | grep -e "$STATE_OK" | wc -l)
	if [ $RDMA_LINKS -gt 0 ]; then
		print_IP4_all
		exit 0
	fi

	# pick up the first 'up' network interface
	NET_IF=$(ip link | grep -v -e "LOOPBACK" | grep -e "state UP" | head -n1 | cut -d: -f2 | cut -d' ' -f2)
	if [ "$NET_IF" == "" ]; then
		#
		# Look for a USB Ethernet network interfaces,
		# which may not have 'state UP',
		# but only 'UP' and 'state UNKNOWN', for example:
		# ... <BROADCAST,MULTICAST,UP,LOWER_UP> ... state UNKNOWN ...
		#
		NET_IF=$(ip link | grep -v -e "LOOPBACK" | grep -e "UP" | grep -e "state UNKNOWN" | head -n1 | cut -d: -f2 | cut -d' ' -f2)
		if [ "$NET_IF" == "" ]; then
			echo "Error: cannot find an active and up network interface"
			exit 1
		fi
	fi
fi

RXE_NAME="rxe_$NET_IF"
sudo rdma link add $RXE_NAME type rxe netdev $NET_IF
if [ $? -ne 0 ]; then
	echo "Error: configuring SoftRoCE failed"
	exit 1
fi

RDMA_LINKS=$(rdma link show | grep -e "$STATE_OK" | grep -e "$NET_IF" | wc -l)
if [ $RDMA_LINKS -lt 1 ]; then
	echo "Error: configuring SoftRoCE for the '$NET_IF' network interface failed"
	exit 1
fi

print_IP4_of $NET_IF
