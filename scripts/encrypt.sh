#!/bin/bash
FILES=./secrets/*

mkdir -p secrets
mkdir -p secrets-encrypted

for f in $FILES
do
  dest=$(echo $f |  sed -e 's/secrets/secrets-encrypted/g')
  echo "Encrypting $f to $dest"
  # take action on each file. $f store current file name
  sops --encrypt $f > $dest
done
