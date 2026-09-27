# AWS Private EKS Infrastructure POC

This project is a hands-on POC for building AWS private infrastructure and Amazon EKS using Terraform.

The goal of this project is to practice infrastructure design, deployment, troubleshooting, and recovery using Infrastructure as Code.

## Network Architecture

- Region: ap-northeast-2
- VPC CIDR: 10.0.0.0/16
- Availability Zones: ap-northeast-2a, ap-northeast-2c

| Subnet Type | ap-northeast-2a | ap-northeast-2c | Purpose |
|---|---|---|---|
| Public | 10.0.1.0/24 | 10.0.2.0/24 | Bastion, Internet-facing Load Balancer |
| Private | 10.0.11.0/24 | 10.0.12.0/24 | Internal Load Balancer |
| Compute | 10.0.21.0/24 | 10.0.22.0/24 | EKS Nodes, CI/CD Runner |
| DB | 10.0.31.0/24 | 10.0.32.0/24 | RDS, Redis |
| VPCE | 10.0.41.0/24 | 10.0.42.0/24 | VPC Interface Endpoints |
| DBX | 10.0.51.0/24 | 10.0.52.0/24 | Databricks |

## Private Network

Workloads are deployed in private subnets.

AWS services are accessed through VPC Endpoints where applicable to minimize public network access.

Planned or configured endpoints include:

- S3 Gateway Endpoint
- ECR API Interface Endpoint
- ECR DKR Interface Endpoint
- STS Interface Endpoint

## Bastion Host

The Bastion host is deployed in a public subnet.

- OS: Amazon Linux 2023
- Instance Type: t3.micro
- Private IP: 10.0.1.10
- IMDSv2: Required
- Root EBS: gp3 / Encrypted
- IAM Instance Profile: SSM permissions
- User Data: Initial management tool installation

The Bastion host is used as a management server for AWS and EKS resources.

## Terraform Command Reference

| Command | Description |
|---|---|
| `terraform init` | Initialize the Terraform working directory |
| `terraform fmt` | Format Terraform configuration files |
| `terraform validate` | Validate the Terraform configuration |
| `terraform plan` | Preview infrastructure changes |
| `terraform apply` | Apply infrastructure changes |
| `terraform destroy` | Destroy Terraform-managed infrastructure |
| `terraform show` | Show the current state or saved plan |
| `terraform state list` | List resources in Terraform state |
| `terraform state show <resource>` | Show details of a specific resource |
| `terraform output` | Show Terraform output values |
| `terraform providers` | Show providers used by the configuration |
| `terraform plan -target=<resource>` | Plan changes for a specific resource |
| `terraform apply -target=<resource>` | Apply changes for a specific resource |

## Terraform Workflow

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

### Check Terraform State

List all resources:

```bash
terraform state list
```

Show a specific resource:

```bash
terraform state show aws_instance.bastion
```

### Target a Specific Resource

Plan a specific resource:

```bash
terraform plan -target=aws_instance.bastion
```

Apply a specific resource:

```bash
terraform apply -target=aws_instance.bastion
```

Terraform operates on resources, not individual `.tf` files.

The `-target` option is mainly used for troubleshooting or specific resource operations.

## Git Command Reference

| Command | Description |
|---|---|
| `git status` | Check the current working tree status |
| `git diff` | Show changes before staging |
| `git add .` | Stage all changes |
| `git commit -m "message"` | Commit staged changes |
| `git push` | Push local commits to the remote repository |
| `git pull` | Pull the latest changes from the remote repository |
| `git branch` | List local branches |
| `git switch master` | Switch to the master branch |
| `git switch -c feature/name` | Create and switch to a new branch |
| `git log --oneline` | Show commit history in a compact format |

## Git Workflow

```bash
git status
git diff
git add .
git status
git commit -m "Update infrastructure"
git push
```

## Project Principles

- Infrastructure is managed with Terraform.
- Infrastructure can be destroyed and rebuilt from code.
- Configuration and deployment history are stored in Git.
- Sensitive information and private keys are not stored in Git.
- Resource versions are explicitly managed where possible.
- Infrastructure failures are intentionally reproduced for troubleshooting practice.

## Planned Architecture

```text
GitHub
   |
GitHub Actions
   |
Self-hosted Runner
   |
   +---- Nexus
   |
   +---- ECR
          |
        Argo CD
          |
         EKS
          |
    ALB / Ingress
```

Future components:

- Amazon EKS
- Amazon ECR
- AWS Load Balancer Controller
- cert-manager
- Argo CD
- GitHub Actions
- Prometheus
- Grafana
- OpenSearch
