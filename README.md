# ☁️ Courm E-Commerce Infrastructure (EKS-based)

**Courm 이커머스 서비스**를 위한 **Amazon EKS (Elastic Kubernetes Service)** 기반의 인프라스트럭처 코드(IaC) 저장소입니다.

## 🏗 아키텍처 개요 (Architecture Overview)

기존 ECS Fargate 환경에서 **Kubernetes(EKS v1.30)** 환경으로 마이그레이션하여, 더욱 유연한 오케스트레이션과 확장성을 갖춘 **MSA(Microservices Architecture)** 환경을 구축합니다.

### 1. 주요 구성 요소 (Key Components)

| 구분 | 구성 요소 | 설명 |
| :--- | :--- | :--- |
| **Compute** | **Amazon EKS** (Control Plane) | 관리형 쿠버네티스 서비스 (v1.30) |
| | **Managed Node Groups** | Data Plane (EC2 `t3.medium` 워커 노드) |
| **Networking** | **Custom VPC** | Public / App(Private) / Data / Mgmt / MQ Subnets 분리 |
| **Load Balancing** | **AWS LB Controller** | K8s Ingress 생성 시 ALB 자동 프로비저닝 (IRSA 연동) |
| **Databases** | **Amazon RDS** | PostgreSQL (Primary + Read Replica) |
| | **Amazon ElastiCache** | Redis (Cluster Mode) |
| **Event Broker** | **Apache Kafka** | EC2 기반 카프카 클러스터 |
| **CI/CD** | **Jenkins** | EC2 기반 빌드/배포 서버 |

### 2. 서비스 통신 흐름 (Traffic Flow)

* **외부 접근 (Ingress Traffic):**
  `User` → `AWS ALB (Ingress)` → `K8s Service (NodePort)` → `Pod (User/Product/Order...)`
* **내부 통신 (Cluster Networking):**
  `User Service` → `K8s CoreDNS (Service Discovery)` → `Product Service`
    * *Example:* `http://product-service.default.svc.cluster.local:8080` 호출

---

## 📂 디렉토리 구조 (Directory Structure)

```text
.
├── environments/
│   └── prod/                 # 프로덕션 환경 배포용 루트 모듈
│       ├── main.tf           # EKS, VPC, RDS, Kafka 등 리소스 조합
│       ├── variables.tf      # 환경 변수 정의
│       ├── outputs.tf        # 클러스터 접속 정보 및 IRSA ARN 출력
│       ├── versions.tf       # Provider 및 Terraform 버전 설정 (Lock 파일 포함)
│       └── terraform.tfvars  # 실제 변수 값 (암호화 필요 정보 제외)
├── global/
│   ├── ecr/                  # ECR 리포지토리 정의
│   ├── route53/              # DNS 관리
│   └── s3-backend/           # Terraform State 저장소
├── modules/                  # 재사용 가능한 Terraform 모듈
│   ├── vpc/                  # 네트워크 (Subnets, NAT, Route Table)
│   ├── eks-cluster/          # EKS 클러스터, 노드그룹, IRSA, Add-ons
│   ├── rds/                  # PostgreSQL 데이터베이스
│   ├── elasticache/          # Redis 클러스터
│   ├── ec2-jenkins/          # Jenkins EC2
│   ├── ec2-kafka/            # Kafka EC2
│   └── security-groups/      # 공통 보안 그룹 규칙
└── README.md
