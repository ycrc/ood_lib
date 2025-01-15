#!/bin/bash

# add path for sacctmgr and scontrol
export PATH=/opt/slurm/current/bin:$PATH
username=$1
# get the partition name and TRES value of the private partitions for a specific user
hostname=$(hostname)
case $hostname in 
    *grace*)
        cmd="for ACCOUNT in $(sacctmgr show user name=$username -s -n -p | cut -d\| -f5 |sort|uniq); do scontrol show partition -o | egrep \$ACCOUNT | cut -d' ' -f1,33; done;"
	;;
    *mccleary*)
	cmd="for ACCOUNT in $(sacctmgr show user name=$username -s -n -p | cut -d\| -f5 |sort|uniq); do scontrol show partition -o | egrep \$ACCOUNT | cut -d' ' -f1,34; done;"
	;;
    *milgram*)
        cmd="for ACCOUNT in $(sacctmgr show user name=$username -s -n -p | cut -d\| -f5 |sort|uniq); do scontrol show partition -o | egrep \$ACCOUNT | cut -d' ' -f1,33; done;"
	;;
esac
eval $cmd
