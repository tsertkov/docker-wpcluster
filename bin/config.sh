#!/usr/bin/env bash

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VAR_DIR=${ROOT_DIR}/var
CONFIG_FILE=${ROOT_DIR}/config.env
source "$CONFIG_FILE"

[ $# -gt 0 ] \
  && echo $(eval echo "\$${1}") \
  && exit

cat <<EOT
ROOT_DIR='$ROOT_DIR'
VAR_DIR='$VAR_DIR'
$(sed "s/^\(.*=\s*\)\(.*\)\$/\1'\2'/" "$CONFIG_FILE")
EOT
