# AWS Private Infrastructure & EKS PoC

Terraform 기반 AWS 프라이빗 인프라 및 Amazon EKS 환경 구축을 위한 개인 PoC 프로젝트입니다. 네트워크 분리, 프라이빗 AWS 서비스 연결, 인프라 코드화 및 운영·복구 시나리오를 중심으로 설계했습니다.

## Project Overview

| 항목 | 내용 |
|---|---|
| Cloud | AWS (ap-northeast-2) |
| IaC | Terraform |
| Network | VPC, Subnet, Route Table, Security Group, VPC Endpoint |
| Container Platform | Amazon EKS (PoC 대상) |
| Operations | Bastion, Amazon ECR, Route 53 Private Hosted Zone |

## Network Architecture

- **VPC:** `10.0.0.0/16`
- **Availability Zones:** `ap-northeast-2a`, `ap-northeast-2c`
- **Subnet separation:** Public, Internal ELB, Compute, DB, VPC Endpoint, Databricks, TGW Attachment
- 워크로드별 서브넷 및 라우팅 분리로 네트워크 경계를 명확하게 구성
- Security Group을 통한 접근 통제와 프라이빗 서비스 통신 고려

## Private Connectivity & Security

- **Amazon S3:** Gateway VPC Endpoint
- **Amazon ECR API / DKR:** Interface VPC Endpoint
- **AWS STS:** Interface VPC Endpoint
- Interface Endpoint에 Private DNS 및 HTTPS(443) 적용
- 관리용 Bastion에 IMDSv2, 암호화된 EBS, IAM Instance Profile 적용
- Route 53 Private Hosted Zone을 통한 내부 DNS 설계

## Terraform Design

- Terraform을 이용한 인프라 구성 및 변경 관리
- 네트워크·보안 리소스를 재사용 가능한 모듈 구조로 관리
- 환경별 설정과 리소스별 구성을 분리하여 확장성 고려
- Terraform Plan 검토 및 State 관리 기반으로 변경·복구 실습

## Repository Structure

```text
aws-eks-poc/
├── dev/        # Terraform infrastructure
├── modules/    # Reusable Terraform modules
├── app/        # Sample application
├── argocd/     # GitOps configuration
├── addons/     # Kubernetes add-on configurations
├── dbx/        # Databricks-related documentation
└── manifests/  # Kubernetes manifests
```

## Roadmap

다음 항목은 구축 완료 기능과 구분되는 **향후 확장 계획**입니다.

- EKS 기반 워크로드 운영 및 GitOps 자동화 고도화
- GitHub Actions / Self-hosted Runner / ECR 기반 CI/CD
- Prometheus·Grafana 기반 모니터링
- AI Agent, RAG, Databricks 연계 실습

## References

- [AWS ECR VPC Endpoints](https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)

> 개인 학습 및 검증용 PoC이며, 운영 환경의 기밀 설정이나 인증정보는 포함하지 않습니다.
