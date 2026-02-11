# 1. 메인 호스트 존 생성
resource "aws_route53_zone" "main" {
  name    = var.domain_name
  comment = "Managed by Terraform (Global)"
}

# 2. Nginx ALB (관리도구용) 연결
resource "aws_route53_record" "admin" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "admin.${var.domain_name}"
  type    = "A"

  alias {
    name                   = "k8s-prodplatformalb-5cf7857503.ap-northeast-2.elb.amazonaws.com"
    zone_id                = "Z7K99PT09SYC0" # ALB 고정 ID
    evaluate_target_health = true
  }
}

# 3. 운영 환경 (Prod NLB) 연결
resource "aws_route53_record" "prod_wildcard" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "*.${var.domain_name}"
  type    = "A"

  alias {
    name                   = "k8s-istiosys-prodgwis-4ca3dfffea.ap-northeast-2.elb.amazonaws.com"
    zone_id                = "Z4Q70MT22SJ3G" # NLB 고정 ID
    evaluate_target_health = true
  }
}
