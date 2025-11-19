#!/bin/bash

MASTER_IP=$(terraform -chdir=terraform output -raw redis_master_private_ip)

echo "Running redis-cli PING test..."

redis-cli -h $MASTER_IP ping

