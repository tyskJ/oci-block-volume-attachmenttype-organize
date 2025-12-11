/************************************************************
Compartment - workload
************************************************************/
resource "oci_identity_compartment" "workload" {
  compartment_id = var.tenancy_ocid
  name           = "block-volume-attachmenttype-organize"
  description    = "For Block Volume AttachmentType Organize"
  enable_delete  = true
}