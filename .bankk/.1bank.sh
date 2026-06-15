#!/bin/bash
# RSA Entity Setup Script with Prompt
# Usage: ./rsa_entity_setup.sh

set -e

echo "Enter entity names (space-separated), e.g. bank user1 user2:"
read -r entities

for entity in $entities; do
    echo "================================ $entity ================================"

    # Create directory
    mkdir -p "$entity"

    # Generate private key
    echo "openssl genpkey -algorithm RSA -out $entity/${entity}_pri.pem"
    openssl genpkey -algorithm RSA -out "$entity/${entity}_pri.pem"

    # Generate public key
    echo "openssl rsa -pubout -in $entity/${entity}_pri.pem -out $entity/${entity}_pub.pem"
    openssl rsa -pubout -in "$entity/${entity}_pri.pem" -out "$entity/${entity}_pub.pem"

    echo "Keys created for $entity:"
    echo "  -> $entity/${entity}_pri.pem"
    echo "  -> $entity/${entity}_pub.pem"
    echo
done

echo "All entities processed successfully."


