
# 🚀 **Redis High Availability Infrastructure (Terraform • Ansible • Jenkins)**

This project demonstrates a fully automated deployment of a **High Availability (HA) Redis Architecture** on AWS using **Terraform**, **Ansible**, and **Jenkins CI/CD**. The entire infrastructure—network, compute, Redis installation, configuration, and health checks—is deployed end-to-end with a single Jenkins pipeline.

It is designed to follow real-world DevOps practices, focusing on automation, modularity, repeatability, and production-grade workflow.

---

# 📡 **Infrastructure Architecture**

This Redis HA setup is deployed on AWS across a secure, multi-subnet architecture.

It includes:

* **1 VPC** (isolated private network)
* **3 Subnets**

  * **1 Public Subnet → Bastion Host**
  * **2 Private Subnets → Redis Master & Redis Replica**
* **Internet Gateway (IGW)** for public access
* **NAT Gateway** for secure outbound access from private subnets
* **Security Groups** with strict inbound/outbound rules
* **EC2 Instances**

  * Bastion (Public)
  * Redis Master (Private)
  * Redis Replica (Private)
* **Routing Tables**, **Key Pair**, and **IAM Permissions**

### 📌 Infra diagram:

<img width="658" height="720" alt="image" src="https://github.com/user-attachments/assets/9108fb11-1323-4c8d-aa11-3390a9071841" />

---

# 📘 **Project Overview**

This project automates:

* AWS infrastructure provisioning with **Terraform**
* Redis installation & configuration using **Ansible roles**
* Dynamic host discovery with **AWS Dynamic Inventory**
* SSH key generation & secure access
* Jenkins-based CI/CD pipeline for one-click deployment
* Automated Redis functional testing

The final output is a **fully running Redis Master–Replica setup** accessible only through the Bastion host.

---

# 📂 **Repository Structure**

```
redis-ha-infra/
├── ansible/
├── jenkins/
├── scripts/
└── terraform/
```

---

# 📁 **Folder and File Breakdown**

## 1. ansible/

Contains everything used for configuration and installation of Redis.

| File                      | Type              | Purpose                                                                   |
| ------------------------- | ----------------- | ------------------------------------------------------------------------- |
| **ansible.cfg**           | Configuration     | Controls Ansible behavior (SSH, retries, inventory, host key checking).   |
| **inventory_aws_ec2.yml** | Dynamic Inventory | Automatically detects EC2 instances using AWS tags. No manual IPs needed. |
| **playbook.yml**          | Playbook          | Installs Redis using Ansible roles and configures master–replica.         |
| **requirements.yml**      | Dependency File   | Installs `amazon.aws` collection needed for discovery.                    |

**Goal:**
Make Redis installation **100% automated**, scalable, and environment-independent.

---

## 2. jenkins/

| File            | Purpose                                                           |
| --------------- | ----------------------------------------------------------------- |
| **Jenkinsfile** | CI/CD pipeline automating Terraform → Ansible → Testing workflow. |

The Jenkins pipeline performs:

1. Clone Git repository
2. Terraform Init / Validate / Apply
3. Install Ansible requirements
4. Execute playbook
5. Test Redis master and replica
6. Show final result in Jenkins console

This creates a **one-click deployment pipeline**.

---

## 3. scripts/

| File              | Purpose                                                    |
| ----------------- | ---------------------------------------------------------- |
| **test_redis.sh** | Verifies Redis connectivity, replication sync, and health. |

Automatically run after provisioning to confirm the cluster works correctly.

---

## 4. terraform/

Top-level directory responsible for provisioning all AWS resources.

| File             | Type            | Purpose                                                     |
| ---------------- | --------------- | ----------------------------------------------------------- |
| **main.tf**      | Root Config     | Connects all modules to build entire infrastructure.        |
| **variables.tf** | Config Inputs   | Stores region, CIDRs, resource names, and module variables. |
| **outputs.tf**   | Helpful Outputs | Provides SSH commands, IPs, and redis-cli instructions.     |
| **ssh.tf**       | Key Generation  | Automatically creates a PEM key for all EC2 instances.      |

### Terraform Modules

#### ▸ modules/network/

* Creates VPC
* Public & private subnets
* Routing tables
* IGW + NAT gateway

#### ▸ modules/bastion/

* Public EC2 instance with SSH access
* Security groups for controlled access

#### ▸ modules/redis/

* Redis master EC2
* Redis replica EC2
* Security groups
* Tags for dynamic discovery

---

# 🔄 **Workflow: How the System Works End-to-End**

### **Step 1 — Terraform Infrastructure**

Terraform creates:

* VPC + Subnets
* Bastion host
* Redis master & replica
* Route tables
* NAT gateway
* Security groups
* Key pair

Terraform outputs:

* Bastion public IP
* Private Redis IPs
* SSH commands
* redis-cli commands

---

### **Step 2 — Ansible Configuration**

Using **AWS dynamic inventory**, Ansible:

* Installs Redis
* Configures master node
* Configures replica
* Sets up replication & persistence
* Performs initial health checks

No manual IP or host update is required.

---

### **Step 3 — Automated Testing**

The script `test_redis.sh` checks:

* Redis master availability
* Replica syncing status
* Redis response
* Port accessibility

---

### **Step 4 — Jenkins CI/CD One-Click Deployment**

The Jenkinsfile automates the entire pipeline:

1. Checkout repository
2. Terraform apply
3. Ansible redis installation
4. Redis validation
5. Display final output

This enables **complete IaC + CM + CI/CD automation**.

---

# 🧪 **How to Run the Project Manually**

### 1. Clone the repository

```
git clone https://github.com/abhinav450718/redis-ha-infra.git
cd redis-ha-infra
```

### 2. Configure AWS CLI

```
aws configure
```

Use region:

```
eu-east-1
```

### 3. Deploy Infrastructure

```
cd terraform
terraform init
terraform apply -auto-approve
```

### 4. Install Redis using Ansible

```
cd ../ansible
ansible-galaxy install -r requirements.yml
ansible-playbook playbook.yml
```

### 5. Test Redis HA setup

```
bash scripts/test_redis.sh
```

---

# 🖥 **One-Click Jenkins Deployment**

* Push code → Jenkins automatically runs the entire pipeline
* Results are displayed in console output
* Redis Master + Replica get fully deployed and tested

---

# 📦 **Final Output Provided by Terraform**

```
bastion_public_ip
redis_master_private_ip
redis_replica_private_ip
ssh_to_bastion
ssh_to_redis_master_via_bastion
ssh_to_redis_replica_via_bastion
redis_cli_master
redis_cli_replica
```

These outputs make it easy to access all servers immediately.

---
Here is a **clean, professional, final “Conclusion” section** you can paste directly into your README:

---

## **🟩 Conclusion**

This project successfully delivers a complete **Redis High Availability (HA) Infrastructure** using **Terraform, Ansible, and Jenkins** in a fully automated pipeline.
Each component—networking, compute provisioning, configuration management, and validation—works in an orchestrated manner to ensure a reliable and production-ready Redis environment.

The modular structure allows:

* **Easy scalability** (add more replicas or environments without redesign).
* **Reusable infrastructure code** through Terraform modules.
* **Consistent configuration** using Ansible roles and playbooks.
* **End-to-end automation** via a single Jenkins pipeline.

---
# 👤 **Author**

**Abhinav Sikarwar**

---

