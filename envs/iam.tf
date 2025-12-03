/************************************************************
Dynamic Group - Compute
************************************************************/
resource "oci_identity_dynamic_group" "compute" {
  compartment_id = var.tenancy_ocid
  name           = "Compute_Dynamic_Group"
  description    = "Compute Dynamic Group"
  matching_rule = format(
    "All {resource.type = 'instance', resource.compartment.id = '%s', tag.Compute.CloudAgent.value = 'true'}",
    oci_identity_compartment.workload.id
  )
  defined_tags = {
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
  }
}

/************************************************************
IAM Policy - Compute
************************************************************/
# resource "oci_identity_policy" "" {
  
# }