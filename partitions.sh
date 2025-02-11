#!/bin/bash
#export PATH="/usr/bin:/opt/slurm/current/bin"

[ "${1}" ] || exit
username="${1}"

cache="/var/cache/ycrc"
partcache="${cache}/scontrol.partitions.json"
assoccache="${cache}/sacctmgr.associations.json"

# get the partition name and TRES value of the private partitions for a specific user
for account in $(jq -r --arg user "${username}" '.associations[] | select(.id.user == $user).account' < "${assoccache}")
do
    jq -r --arg account "${account}" '.partitions[] | select(.accounts.allowed | test("(^|,)" + $account + "(,|$)")) | "PartitionName=" + .name + " TRES=" + .tres.configured' < "${partcache}"
done
