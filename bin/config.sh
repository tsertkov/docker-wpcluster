#!/usr/bin/env bash

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VAR_DIR=${ROOT_DIR}/var
CONFIG_FILE=${ROOT_DIR}/config.env
source "$CONFIG_FILE"

if [ $# -gt 0 ]; then
  config_var=$(eval echo -n "\$${1}")
  if [ -n "$config_var" ]; then
    echo -n "$config_var"
    exit
  fi

  exit 1
fi

cat <<EOT
ROOT_DIR='$ROOT_DIR'
VAR_DIR='$VAR_DIR'
$(sed -e "/^#/d" -e "s/^\(.*=\s*\)\(.*\)\$/\1'\2'/" "$CONFIG_FILE")
EOT
