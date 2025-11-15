terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.26.0"
    }
  }
}

provider "oci" {
  auth                = "SecurityToken"
  config_file_profile = "DEV-ADMIN"
  region              = "ap-tokyo-1"
}
