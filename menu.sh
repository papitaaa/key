#!/bin/bash

while true; do
    echo "              |               "
    echo "            Menu              "
    echo "------------------------------------"
    echo "1. Symmetric AES (password)"
    echo "2. Symmetric AES (random key + IV)"
    echo "3. Symmetric AES (random key, no IV)"
    echo "4. PBKDF2 AES"
    echo "5. Symmetric 3DES"
    echo "6. RSA Asymmetric Encryption/Decryption"
    echo "7. Hash a File"
    echo "8. RSA Sign and Verify"
    echo "9. DSA Sign and Verify"
    echo "0. Exit"
    echo "-------------------------------------"
    read -p "select: " choice

    case $choice in
        1)
            echo "openssl enc -aes-256-cbc -in plaintext.txt -out encrypted.txt -pass pass:mysecret"
            echo "openssl enc -d -aes-256-cbc -in encrypted.txt -out decrypted.txt -pass pass:mysecret"
            echo "diff plaintext.txt decrypted.txt"
            ;;
        2)
            echo "openssl rand -out secret.key 32"
            echo "openssl rand -out iv.bin 16"
            echo "xxd -p secret.key"
            echo "xxd -p iv.bin"
            echo "openssl enc -aes-256-cbc -in message.txt -out message.txt.enc -K \$(xxd -p secret.key | tr -d '\\n') -iv \$(xxd -p iv.bin | tr -d '\\n')"
            echo "openssl enc -aes-256-cbc -d -in message.txt.enc -out decrypted.txt -K \$(xxd -p secret.key | tr -d '\\n') -iv \$(xxd -p iv.bin | tr -d '\\n')"
            ;;
        3)
            echo "openssl rand -out secret.key 32"
            echo "openssl enc -aes-256-cbc -in plaintext.txt -out encrypted.txt -pass file:secret.key"
            echo "openssl enc -d -aes-256-cbc -in encrypted.txt -out decrypted.txt -pass file:secret.key"
            ;;
        4)
            echo "openssl enc -aes-256-cbc -in plaintext.txt -out encrypted.txt -pass pass:mysecret -pbkdf2"
            echo "openssl enc -d -aes-256-cbc -in encrypted.txt -out decrypted.txt -pass pass:mysecret -pbkdf2"
            ;;
        5)
            echo "openssl enc -des-ede3-cbc -pbkdf2 -in plaintext.txt -out encrypted.txt"
            echo "openssl enc -des-ede3-cbc -pbkdf2 -d -in encrypted.txt -out decrypted.txt"
            ;;
        6)
            echo "openssl genpkey -algorithm RSA -out bank_pri.pem -pkeyopt rsa_keygen_bits:2048"
            echo "openssl rsa -pubout -in bank_pri.pem -out bank_pub.pem"
            echo "openssl genpkey -algorithm RSA -out acc1_pri.pem -pkeyopt rsa_keygen_bits:2048"
            echo "openssl rsa -pubout -in acc1_pri.pem -out acc1_pub.pem"
            echo "openssl pkeyutl -encrypt -pubin -inkey bank_pub.pem -in acc1_message.txt -out acc1_encrypted.txt"
            echo "openssl pkeyutl -decrypt -inkey bank_pri.pem -in acc1_encrypted.txt -out acc1_decrypted.txt"
            echo "diff acc1_encrypted.txt acc1_encrypted.txt"
            echo "openssl pkeyutl -encrypt -pubin -inkey acc1_pub.pem -in bank_reply_to_acc1.txt -out encrypted_reply.txt"
            echo "openssl pkeyutl -decrypt -inkey acc1_pri.pem -in encrypted_reply.txt -out decrypted_reply.txt"
            echo "sha256sum encrypted_reply.txt decrypted_reply.txt"
            ;;
        7)
            echo "openssl dgst -sha256 -out hash1.txt myfile.txt"
            echo "openssl dgst -sha256 -out hash2.txt myfile.txt"
            echo "diff hash1.txt hash2.txt"
            ;;
        8)
            echo "openssl genpkey -algorithm RSA -out keyfile.pem -aes256"
            echo "openssl rsa -in keyfile.pem -pubout -out public_key.pem"
            echo "openssl dgst -sha256 -sign keyfile.pem -out file1.txt.sha256.sig file1.txt"
            echo "openssl dgst -sha256 -verify public_key.pem -signature file1.txt.sha256.sig file1.txt"
            ;;
        9)
            echo "openssl dsaparam -out dsaparam.pem 2048"
            echo "openssl gendsa -out private_dsa.pem dsaparam.pem"
            echo "openssl dsa -in private_dsa.pem -pubout -out public_dsa.pem"
            echo "openssl dgst -sha25
6 -sign private_dsa.pem -out signature.bin message.txt"
            echo "openssl dgst -sha256 -verify public_dsa.pem -signature signature.bin message.txt"
            ;;
        0)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid choice, try again."
            ;;
    esac
done
