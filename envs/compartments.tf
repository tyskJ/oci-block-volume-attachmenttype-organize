/************************************************************
Compartment - workload
************************************************************/
resource "oci_identity_compartment" "workload" {
  compartment_id = var.tenancy_ocid
  name           = "workload"
  description    = "Wokload Compartment"
  enable_delete  = true
}