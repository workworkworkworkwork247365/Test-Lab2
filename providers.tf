terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
      version = "2.3.1"
    }
  }
}
provider equinix {
  alias = "primary"
  client_id     = var.primary_equinix_client_id
  client_secret = var.primary_equinix_client_secret
  auth_token = var.auth_token
}

provider equinix {
  alias = "secondary"
  client_id     = var.secondary_equinix_client_id
  client_secret = var.secondary_equinix_client_secret
}

