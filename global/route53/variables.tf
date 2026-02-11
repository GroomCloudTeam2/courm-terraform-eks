variable "domain_name" {
  description = "구매한 메인 도메인 이름 (예: example.com)"
  type        = string
  default     = "example.com"
}

variable "nginx_alb_dns_name" {
  description = "Nginx Ingress용 ALB의 DNS 이름"
  type        = string
}

variable "istio_prod_nlb_dns_name" {
  description = "Istio Prod Gateway용 NLB의 DNS 이름"
  type        = string
}

variable "istio_dev_nlb_dns_name" {
  description = "Istio Dev Gateway용 NLB의 DNS 이름"
  type        = string
}

variable "elb_zone_id" {
  description = "AWS 리전별 ELB 호스트 존 ID (서울 리전은 고정값)"
  type        = string
  default     = "Z2ABC12345678" # 서울(ap-northeast-2) ALB/NLB 고정 ID
}
