# terraform/environments/prod/backend.tf

terraform {
  backend "s3" {
    # 버킷 이름
    bucket         = "courm-ecommerce-tf-state-storage"
    
    # 이 파일이 저장될 경로
    key            = "prod/terraform.tfstate"
    
    region         = "ap-northeast-2"
    
    # DynamoDB 테이블 이름
    dynamodb_table = "courm-ecommerce-tf-locks"
    
    encrypt        = true
  }
}
