#!/bin/bash
FILES=./secret-encrypted

mkdir -p secret
mkdir -p secret-encrypted

for f in $(find $FILES -type f)
do
  dest=$(echo $f |  sed -e 's/secret-encrypted/secret/g')
  echo "Decrypting $f to $dest"

  dir=$(dirname -- "$dest")
  mkdir -p $dir  

  sops --decrypt $f > $dest
done
