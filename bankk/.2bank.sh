#!/bin/bash
# RSA Encrypt/Decrypt

set -e

echo "============================== RSA Encrypt and Decrypt =============================="

# Step 1: User1 encrypts msg2bank.txt with bank's public key
echo "openssl pkeyutl -encrypt -pubin -inkey bank/bank_pub.pem -in user1/msg2bank.txt -out user1/msg2bank.enc"
openssl pkeyutl -encrypt -pubin -inkey bank/bank_pub.pem -in user1/msg2bank.txt -out user1/msg2bank.enc

echo "mv user1/msg2bank.enc bank/"
mv user1/msg2bank.enc bank/

# Step 2: Bank decrypts with its private key
echo "openssl pkeyutl -decrypt -inkey bank/bank_pri.pem -in bank/msg2bank.enc -out bank/msg2bank.dec"
openssl pkeyutl -decrypt -inkey bank/bank_pri.pem -in bank/msg2bank.enc -out bank/msg2bank.dec

echo "Decrypted message at Bank:"
cat bank/msg2bank.dec
