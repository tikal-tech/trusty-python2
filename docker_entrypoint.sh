#!/bin/bash
set -e

# Alters user uid/gid to match TARGET_DIR / curr dir
DIR=${TARGET_DIR:-.}
TARGET_GID=$(stat -c "%g" ${DIR})
TARGET_UID=$(stat -c "%u" ${DIR})

EXISTS=$(cat /etc/group | grep ${TARGET_GID} | wc -l)
# Create new group using target GID and add nobody user
  if [ $EXISTS == "0" ]; then
    sudo groupmod -g $TARGET_GID ubuntu
    sudo usermod -u ${TARGET_UID} ubuntu
  else
    # GID exists, find group name and add
    GROUP=$(getent group $TARGET_GID | cut -d: -f1)
    sudo usermod -aG $GROUP -u ${TARGET_UID} ubuntu
  fi
"$@"
