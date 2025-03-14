//get IP of local machine
data "http" "get_local_machine_ip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  //set local machine IP to CIDR
  local_machine_ip   = chomp(data.http.get_local_machine_ip.response_body)
  local_machine_cidr = "${local.local_machine_ip}/32"

  last_updated = formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())
}

output "local_machine_ip" {
  value = local.local_machine_ip
}

output "local_machine_cidr" {
  value = local.local_machine_cidr
}

output "last_updated" {
  value = local.last_updated
}
