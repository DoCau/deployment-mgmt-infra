terraform {
  backend "s3" {
    bucket = "prj-deployment-mgmt-caudt1"
    key    = "envs/dev/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
