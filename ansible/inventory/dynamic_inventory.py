#!/usr/bin/env python3
import json
import subprocess

# Load IPs from terraform output
def terraform_output(var):
    result = subprocess.run(
        ["terraform", "output", "-raw", var],
        cwd="../terraform",
        capture_output=True,
        text=True
    )
    return result.stdout.strip()

redis_master_ip = terraform_output("redis_master_private_ip")
redis_replica_ip = terraform_output("redis_replica_private_ip")
bastion_ip = terraform_output("bastion_public_ip")
private_key_path = terraform_output("private_key_path")

# Inventory JSON
inventory = {
    "all": {
        "hosts": [],
        "vars": {
            "ansible_user": "ubuntu",
            "ansible_ssh_private_key_file": private_key_path,
            "ansible_ssh_common_args": f"-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -J ubuntu@{bastion_ip}"
        }
    },
    "redis_master": {
        "hosts": [redis_master_ip],
        "vars": {}
    },
    "redis_replica": {
        "hosts": [redis_replica_ip],
        "vars": {}
    }
}

print(json.dumps(inventory))
