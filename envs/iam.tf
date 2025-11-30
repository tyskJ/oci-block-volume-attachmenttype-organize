/************************************************************
Dynamic Group - Compute
************************************************************/
# resource "oci_identity_dynamic_group" "test" {
#   compartment_id = var.tenancy_id
#   name           = "test"
#   description    = "test"
#   matching_rule = format(
#     "All {resource.type = 'instance', resource.compartment.id = '%s', tag.Compute.CloudAgent='true'}",
#     var.compartment_id
#   )
#   defined_tags = {
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
#   }
# }

/************************************************************
IAM Policy - Compute
************************************************************/
