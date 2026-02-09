# environments/prod/helm.tf

# ------------------------------------------------------------------------------
# 1. IAM Role for AWS Load Balancer Controller (IRSA)
# [주의] modules/eks-cluster/main.tf의 lb_role은 반드시 삭제/주석 처리해야 충돌 안 남
# ------------------------------------------------------------------------------
module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30" # [업데이트] 최신 모듈 버전 사용 권장

  role_name                              = "${var.environment}-lb-controller-role"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn = module.eks_cluster.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# 2. Helm Chart: AWS Load Balancer Controller
# ------------------------------------------------------------------------------
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  version    = "1.11.0"

  # 클러스터 이름
  set {
    name  = "clusterName"
    value = module.eks_cluster.cluster_name
  }

  # Service Account 생성 활성화
  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  # 위에서 만든 IAM Role ARN 연결
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.lb_role.iam_role_arn
  }

  # Service Account 이름 지정
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  # EKS 클러스터와 IAM Role이 다 만들어진 후 설치 시작
  depends_on = [
    module.eks_cluster,
    module.lb_role
  ]
}
