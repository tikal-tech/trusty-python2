#!/bin/bash
set -e

# Alters user uid/gid to match TARGET_DIR
DIR=${TARGET_DIR:-.} # fallback to workdir
TARGET_GID=$(stat -c "%g" ${DIR})
TARGET_UID=$(stat -c "%u" ${DIR})

EXISTS=$(cat /etc/group | grep ${TARGET_GID} | wc -l)
# Create new group using target GID and add nobody user
  if [ $EXISTS == "0" ]; then
    groupadd -g $TARGET_GID tempgroup
    sudo usermod -ag tempgroup sudo ubuntu
  else
    # GID exists, find group name and add
    GROUP=$(getent group $TARGET_GID | cut -d: -f1)
    sudo usermod -aG $GROUP ubuntu
  fi
# now executes whatever the user passes
"$@"
