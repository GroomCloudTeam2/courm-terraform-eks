output "route53_zone_id" {
  description = "생성된 Route 53 호스트 존 ID"
  value       = aws_route53_zone.main.zone_id
}

output "route53_name_servers" {
  description = "도메인 등록처에 등록해야 할 4개의 네임서버 리스트"
  value       = aws_route53_zone.main.name_servers
}

output "admin_url" {
  description = "관리 도구 접속 주소"
  value       = "admin.${var.domain_name}"
}

output "prod_wildcard_url" {
  description = "운영 서비스 와일드카드 주소"
  value       = "*.${var.domain_name}"
}
