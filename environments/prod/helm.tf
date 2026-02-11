# environments/prod/helm.tf

# ------------------------------------------------------------------------------
# 1. IAM Role for AWS Load Balancer Controller (IRSA)
# [주의] modules/eks-cluster/main.tf의 lb_role은 반드시 삭제/주석 처리해야 충돌 안 남
# ------------------------------------------------------------------------------
module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30"

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
