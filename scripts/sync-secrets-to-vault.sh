#!/bin/sh
if [ -x "$(command -v safe)" ]; then
    echo "Safe is installed... continuing..."
else
    echo "safe must be installed: https://github.com/starkandwayne/safe"
    exit 1
fi

if [[ -z "$VAULT_ADDR" ]]; then
    echo "Must provide VAULT_ADDR in environment, run \"eval \$(jx get vault-config)\"" 1>&2
    exit 1
fi

if [[ -z "$VAULT_TOKEN" ]]; then
    echo "Must provide VAULT_TOKEN in environment, run \"eval \$(jx get vault-config)\"" 1>&2
    exit 1
fi

for envFile in $(find secret -type f -name "*.env")
do
  # same path without .env
  vaultpath=${envFile//\.env/}
  echo "Syncing $vaultpath"

  # reduce lines into a string separated by " "
  envVars=""
  IFS=$'\n'       # make newlines the only separator
  set -f          # disable globbing
  for line in $(cat < "$envFile"); do
    envVars="$envVars\"$line\" "
  done

  # echo "Running \"safe set $vaultpath ${envVars}\"\n"
  eval "safe set $vaultpath ${envVars}"
done
