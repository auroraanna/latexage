# latexage

This is a utility to generate paper backups of age keys. These backups include the keys in their regular alphanumeric form as well as QR codes.

## Prerequsites

This is designed to run under Linux, and needs age, bash, and latex installed.

## Running

In this directory, run the generator by piping the secret key into the script, i.e.:

`cd latexage`

`cat age-secret-key | ./latexage.sh`

or for testing

`age-keygen | ./latexage.sh`
