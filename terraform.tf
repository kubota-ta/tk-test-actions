terraform { 
  backend "s3" { 
    bucket = "kubotat-test-actions" 
    key    = "terraform.tfstate" 
    region = "ap-northeast-1" 
  } 
}
