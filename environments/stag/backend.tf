terraform {
  backend "s3" {
    bucket  = "project_deployment_mgmt_tfstate_caudt1"
    key     = "envs/stag/terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = false
  }
}
