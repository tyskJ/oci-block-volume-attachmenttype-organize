data "oci_identity_availability_domain" "ads" {
  compartment_id = var.compartment_id
  ad_number      = 1
}

data "oci_identity_fault_domains" "fds" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domain.ads.name
}
