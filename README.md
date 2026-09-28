# AWS Private EKS Infrastructure POC
This project is a hands-on POC for building AWS private infrastructure and Amazon EKS using Terraform.
The goal of this project is to practice infrastructure design, deployment, troubleshooting, and recovery using Infrastructure as Code.
---
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
---
## Private Network
AWS services are accessed through VPC Endpoints where applicable to minimize public network access.
Configured or planned endpoints include:
| AWS Service | Endpoint Type | Purpose |
|---|---|---|
| Amazon S3 | Gateway | Private S3 access and ECR image layer access |
| Amazon ECR API | Interface | ECR API operations |
| Amazon ECR DKR | Interface | Docker image push and pull |
| AWS STS | Interface | Private access to AWS STS APIs |
### ECR Private Network Flow
```text
Bastion / EKS Node
       |
       +---- ECR API
       |       |
       |    ecr.api
       |    Interface VPCE
       |
       +---- Docker Push / Pull
       |       |
       |    ecr.dkr
       |    Interface VPCE
       |
       +---- ECR Image Layers
       |       |
       |      S3
       |    Gateway VPCE
       |
       +---- AWS STS
               |
              sts
          Interface VPCE
```
Interface VPC Endpoints use TCP/443 and Private DNS.
The S3 Gateway Endpoint is associated with the required route tables.
---
## Private DNS - Amazon Route 53
A Route 53 Private Hosted Zone is used for internal DNS resolution inside the VPC.
- Domain: steve316.shop
- Hosted Zone Type: Private Hosted Zone
- Purpose: Internal service DNS for private workloads
- Internet Gateway is not required for Private Hosted Zone DNS resolution.
- Route 53 Resolver endpoints are not required for DNS queries originating from the associated VPC.
Planned internal records:
portal.steve316.shop  -> Internal ALB
argocd.steve316.shop  -> Internal ALB
grafana.steve316.shop -> Internal ALB
Public ACM certificate validation and HTTPS configuration will be implemented separately.
## Bastion Host
The Bastion host is deployed in a public subnet and is used as a management server for AWS and EKS resources.
- OS: Amazon Linux 2023
- Instance Type: t3.micro
- Private IP: 10.0.1.10
- IMDSv2: Required
- Root EBS: gp3 / Encrypted
- IAM Instance Profile: SSM permissions
- User Data: Initial management tool installation
### Installed Packages
The following tools are installed on the Bastion host through User Data.
| Package | Version | Purpose |
|---|---|---|
| AWS CLI | 2.33.15 | Manage AWS resources from the command line |
| Git | 2.50.1 | Manage source code and Git repositories |
| jq | 1.8.1 | Process and filter JSON data |
| Docker | 25.0.14 | Build and manage container images |
| kubectl | 1.36.2 | Manage Kubernetes and Amazon EKS resources |
| eksctl | 0.215.0 | Create and manage Amazon EKS clusters |
| Helm | 3.21.4 | Manage Kubernetes applications using Helm charts |
| curl | 8.21.0 | Send HTTP/HTTPS requests and test endpoints |
Package versions are explicitly managed where applicable to maintain compatibility with the EKS environment.
---
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
| `terraform state rm <resource>` | Remove a resource from Terraform state without deleting the actual resource |
| `terraform state mv <source> <destination>` | Change a Terraform resource address in state |
| `terraform import <resource> <id>` | Import an existing infrastructure resource into Terraform state |
| `terraform output` | Show Terraform output values |
| `terraform providers` | Show providers used by the configuration |
| `terraform plan -target=<resource>` | Plan changes for a specific resource |
| `terraform apply -target=<resource>` | Apply changes for a specific resource |
---
## Terraform Workflow
```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```
---
## Terraform State Management
Terraform state maps Terraform resource addresses to actual infrastructure resources.
### Check Terraform State
List all resources:
```bash
terraform state list
```
Show a specific resource:
```bash
terraform state show aws_instance.bastion
```
### Remove Resource from State
```bash
terraform state rm <RESOURCE_ADDRESS>
```
Removes a resource from Terraform state without deleting the actual AWS resource.
Example:
```bash
terraform state rm 'aws_vpc_endpoint_route_table_association.s3_compute[0]'
```
Typical use cases:
- Stop managing a resource with Terraform
- Change the Terraform management method
- Remove obsolete or duplicate state entries
### Move Resource in State
```bash
terraform state mv <SOURCE_ADDRESS> <DESTINATION_ADDRESS>
```
Changes the Terraform resource address stored in state without recreating the actual infrastructure resource.
Example:
```bash
terraform state mv \
  aws_route_table_association.bastion_public \
  'aws_route_table_association.public[0]'
```
Typical use cases:
- Rename a Terraform resource
- Convert a resource to `count` or `for_each`
- Move resources into modules
- Refactor Terraform code without recreating infrastructure
### Import Existing Resource
```bash
terraform import <RESOURCE_ADDRESS> <RESOURCE_ID>
```
Imports an existing infrastructure resource into Terraform state.
Example:
```bash
terraform import aws_vpc.main vpc-xxxxxxxxxxxxxxxxx
```
Typical use cases:
- An AWS resource already exists
- Start managing an existing resource with Terraform
- Adopt manually created infrastructure into IaC
The Terraform configuration must also exist and should describe the imported resource.
### State Command Summary
```text
state rm  = Remove a resource from Terraform management
state mv  = Change a Terraform resource address
import    = Bring existing infrastructure under Terraform management
```
Always review `terraform plan` after state operations.
---
## Target a Specific Resource
Plan a specific resource:
```bash
terraform plan -target=aws_instance.bastion
```
Apply a specific resource:
```bash
terraform apply -target=aws_instance.bastion
```
Terraform operates on resources, not individual `.tf` files.
The `-target` option is mainly used for troubleshooting or specific resource operations rather than the normal Terraform workflow.
---
## Amazon ECR Practice
The ECR repository is used to store container images for the EKS POC.
Repository:
```text
a-ecr-steve-dev-ane2-app01
```
Region:
```text
ap-northeast-2
```
### 1. Verify AWS Identity
```bash
aws sts get-caller-identity
```
### 2. Verify ECR Repository
```bash
aws ecr describe-repositories \
  --region ap-northeast-2
```
### 3. Configure Variables
```bash
AWS_REGION=ap-northeast-2
AWS_ACCOUNT_ID=$(aws sts get-caller-identity \
  --query Account \
  --output text)
ECR_REPOSITORY=a-ecr-steve-dev-ane2-app01
ECR_REGISTRY=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
```
Verify variables:
```bash
echo ${AWS_ACCOUNT_ID}
echo ${ECR_REGISTRY}
echo ${ECR_REPOSITORY}
```
### 4. Login to Amazon ECR
```bash
aws ecr get-login-password \
  --region ${AWS_REGION} \
  | docker login \
      --username AWS \
      --password-stdin ${ECR_REGISTRY}
```
### 5. Check Local Docker Images
```bash
docker images
```
### 6. Tag Docker Image
```bash
docker tag steve-app:latest \
  ${ECR_REGISTRY}/${ECR_REPOSITORY}:v1
```
### 7. Verify Image Tag
```bash
docker images
```
### 8. Push Image to ECR
```bash
docker push \
  ${ECR_REGISTRY}/${ECR_REPOSITORY}:v1
```
### 9. Verify Image in ECR
```bash
aws ecr describe-images \
  --repository-name ${ECR_REPOSITORY} \
  --region ${AWS_REGION}
```
### 10. Remove Local Image
Remove the ECR-tagged local image before testing pull.
```bash
docker rmi \
  ${ECR_REGISTRY}/${ECR_REPOSITORY}:v1
```
### 11. Pull Image from ECR
```bash
docker pull \
  ${ECR_REGISTRY}/${ECR_REPOSITORY}:v1
```
### 12. Verify Pulled Image
```bash
docker images
```
### 13. Run Container
```bash
docker run --rm \
  ${ECR_REGISTRY}/${ECR_REPOSITORY}:v1
```
### 14. Add Another Image Tag
```bash
docker tag \
  ${ECR_REGISTRY}/${ECR_REPOSITORY}:v1 \
  ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest
```
Push the additional tag:
```bash
docker push \
  ${ECR_REGISTRY}/${ECR_REPOSITORY}:latest
```
### 15. Verify Image Tags
```bash
aws ecr describe-images \
  --repository-name ${ECR_REPOSITORY} \
  --region ${AWS_REGION}
```
### 16. Delete an Image Tag
```bash
aws ecr batch-delete-image \
  --repository-name ${ECR_REPOSITORY} \
  --image-ids imageTag=latest \
  --region ${AWS_REGION}
```
### ECR Practice Flow
```text
AWS Identity
     |
     v
ECR Login
     |
     v
Docker Image
     |
     v
Tag Image
     |
     v
Push to ECR
     |
     v
Verify Image
     |
     v
Remove Local Image
     |
     v
Pull from ECR
     |
     v
Run Container
     |
     v
Additional Tag
     |
     v
Delete Image Tag
```
---
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
---
## Git Workflow
```bash
git status
git diff
git add .
git status
git commit -m "Update infrastructure"
git push
```
---
## Project Principles
- Infrastructure is managed with Terraform.
- Infrastructure can be destroyed and rebuilt from code.
- Configuration and deployment history are stored in Git.
- Sensitive information and private keys are not stored in Git.
- Resource versions are explicitly managed where possible.
- Infrastructure failures are intentionally reproduced for troubleshooting practice.
- Terraform state changes are reviewed before infrastructure changes are applied.
- Private AWS service access is implemented through VPC Endpoints where applicable.
---
## Repository Structure
aws-eks-poc/
├── dev/        # AWS / Terraform infrastructure
├── argocd/     # Kubernetes / GitOps
├── ai/         # Agent / LiteLLM / Bedrock / RAG / Embedding / Reranker
├── dbx/        # Databricks
├── packages/   # Closed-network package and import management
└── docs/       # Architecture and project documentation
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
- Nexus Repository
- AWS Load Balancer Controller
- cert-manager
- Argo CD
- GitHub Actions
- Prometheus
- Grafana
- OpenSearch
- Databricks
- AI Agent
- LiteLLM
- Amazon Bedrock
- RAG / Embedding / Reranker
---
## AWS Official Documentation
### Amazon ECR
- ECR VPC Endpoints / AWS PrivateLink  
  https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html
- Pushing Docker Images to Amazon ECR  
  https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html
- Pulling Docker Images from Amazon ECR  
  https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-pull-ecr-image.html
- Amazon ECR CLI Getting Started  
  https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html
- AWS CLI - get-login-password  
  https://docs.aws.amazon.com/cli/latest/reference/ecr/get-login-password.html
### Terraform
- Terraform State Command  
  https://developer.hashicorp.com/terraform/cli/commands/state
- Terraform State Remove  
  https://developer.hashicorp.com/terraform/cli/commands/state/rm
- Terraform State Move  
  https://developer.hashicorp.com/terraform/cli/commands/state/mv
- Terraform Import  
  https://developer.hashicorp.com/terraform/cli/commands/import