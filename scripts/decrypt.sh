#!/bin/bash
FILES=./secrets-encrypted/*

mkdir -p secrets
mkdir -p secrets-encrypted

for f in $FILES
do
  dest=$(echo $f |  sed -e 's/secrets-encrypted/secrets/g')
  echo "Decrypting $f to $dest"
  # take action on each file. $f store current file name
  sops --decrypt $f > $dest
done
