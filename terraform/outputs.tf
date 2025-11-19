output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "redis_master_private_ip" {
  value = module.redis_master.private_ip
}

output "redis_replica_private_ip" {
  value = module.redis_replica.private_ip
}

output "private_key_path" {
  value = "${path.root}/redis_key.pem"
}

output "ssh_to_bastion" {
  value = "ssh -i ${path.root}/redis_key.pem ubuntu@${module.bastion.bastion_public_ip}"
}

output "ssh_to_redis_master_via_bastion" {
  value = "ssh -i ${path.root}/redis_key.pem -J ubuntu@${module.bastion.bastion_public_ip} ubuntu@${module.redis_master.private_ip}"
}

output "ssh_to_redis_replica_via_bastion" {
  value = "ssh -i ${path.root}/redis_key.pem -J ubuntu@${module.bastion.bastion_public_ip} ubuntu@${module.redis_replica.private_ip}"
}

output "redis_cli_master" {
  value = "redis-cli -h ${module.redis_master.private_ip} -p 6379"
}

output "redis_cli_replica" {
  value = "redis-cli -h ${module.redis_replica.private_ip} -p 6379"
}
