data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_identity_fault_domains" "fds" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
}
