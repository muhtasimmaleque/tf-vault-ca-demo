# Make sure to 'source ./env-vars.sh'
terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "2.14.0"
    }
  }
}
provider "vault" {
  # Configuration options
}
#
# Role for server certs
#
resource "vault_pki_secret_backend_role" "role-server-cer" {
  backend = vault_mount.pki_int.path
  name = "server-cert-for-${var.server_cert_domain}"
  allowed_domains = [ var.server_cert_domain ]
  allow_subdomains = true
  allow_glob_domains = false
  allow_any_name = false
  enforce_hostnames = true
  allow_ip_sans = true
  server_flag = true
  client_flag = false 
  ou = ["Development"]
  organization = ["TeKanAid Solutions Inc."]
  country = ["Canada"]
  locality = ["Toronto"]
  # 2 years
  max_ttl = 63113904 
  # 30 days
  ttl = 2592000
  no_store = false

}
resource "vault_pki_secret_backend_role" "vault-client-cert" {
  backend = vault_mount.pki_int.path
  name = "client-cert-for-${var.client_cert_domain}"
  allowed_domains = [ var.client_cert_domain ]
  allow_subdomains = false
  allow_glob_domains = false
  allow_bare_domains = true # needed for email address verification
  allow_any_name = false 
  enforce_hostnames = true
  allow_ip_sans = true
  #allowed_other_sans = ["1.2.840.113549.1.9.1;utf8:emailAddress"]
  server_flag = true
  client_flag = true 
  ou = ["Development"]
  organization = ["TeKanAid Solutions Inc."]
  country = ["Canada"]
  locality = ["Toronto"]
  # 2 years
  max_ttl = 63113904 
  # 30 days
  ttl = 2592000
  no_store = false
}
