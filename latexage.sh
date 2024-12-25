#!/usr/bin/env bash

stdin=$(cat)

# we need a place to store working files
mkdir -p "keytemp"

# how to get rid of stderr without writing and reading from a file
secretkey=$(echo -n "$stdin" | tail --lines 1 > keytemp/miau && cat keytemp/miau)
rm keytemp/miau
publickey="$(echo -n $secretkey | age-keygen -y)"

# this takes a set of information, and calls latex to generate the page
generate_key_pdf() {
  echo "running latex for key pair with public key $publickey"
  
  conffile=keytemp/$publickey-config.tex
  keyfile=keytemp/$publickey-key
  
  # create a file to define variables for latex
  touch $conffile
  echo "\def \publickey {$publickey}" >> $conffile
  echo "\def \secretkey {$secretkey}" >> $conffile
  
  # generate secret key QR code with highest error correction level
  echo -n $secretkey | qrencode -i --level=M -o keytemp/$publickey-secret-qr.png

  # generate secret key QR code with highest error correction level
  echo -n "$publickey" | qrencode -i --level=M -o keytemp/$publickey-public-qr.png
  
  ln -s $publickey-config.tex keytemp/config.tex
  
  # compile pdf
  lualatex  -jobname=$publickey -interaction=batchmode -shell-escape  secretkeybackup.tex
  ret=$?
  if [[ $ret != 0 ]]; then
    echo "Error generating $publickey.pdf. Check $publickey.log for Latex errors."
  fi
  
  rm keytemp/config.tex
  
  rm keytemp/$publickey*
  
}

generate_key_pdf

rm -rf *.aux
rm -rf keytemp
