/************************************************************
Tag NameSpace & Tag Key Values
************************************************************/
resource "oci_identity_tag_namespace" "namespace_compute" {
  compartment_id = var.compartment_id
  name           = "Compute"
  description    = "NameSpace For Compute"
  is_retired     = false
}

resource "oci_identity_tag" "namespace_compute_cloudagent" {
  tag_namespace_id = oci_identity_tag_namespace.namespace_compute.id
  name             = "CloudAgent"
  description      = "CloudAgent is installed"
  is_cost_tracking = false
  is_retired       = false
  validator {
    validator_type = "ENUM"
    values         = ["true", "false"]
  }
}

resource "oci_identity_tag_namespace" "namespace_common" {
  compartment_id = var.compartment_id
  name           = "Common"
  description    = "NameSpace for Common"
  is_retired     = false
}

resource "oci_identity_tag" "namespace_common_system" {
  tag_namespace_id = oci_identity_tag_namespace.namespace_common.id
  name             = "System"
  description      = "Defined System"
  is_cost_tracking = true
  is_retired       = false
  validator {
    validator_type = "ENUM"
    values         = ["oci-block-volume-attachment-organize"]
  }
}

/************************************************************
Default Tag
************************************************************/
resource "oci_identity_tag_default" "default_system" {
  compartment_id    = var.compartment_id
  tag_definition_id = oci_identity_tag.namespace_common_system.id
  value             = oci_identity_tag.namespace_common_system.validator[0].values[0]
  is_required       = true
}
