/************************************************************
Dynamic Group - Compute
************************************************************/
resource "oci_identity_dynamic_group" "compute" {
  compartment_id = var.tenancy_ocid
  name           = "Compute_Dynamic_Group"
  description    = "Compute Dynamic Group"
  matching_rule = format(
    "All {instance.compartment.id = '%s', tag.Compute.CloudAgent.value = 'true'}",
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
resource "oci_identity_policy" "compute_for_agent_volmng" {
  compartment_id = oci_identity_compartment.workload.id
  description    = "OCI Compute Policy for CloudAgent Volume Management"
  name           = "compute-cloudagent-volume-management-policy"
  statements = [
    format("allow dynamic-group %s to use instances in compartment %s", oci_identity_dynamic_group.compute.name, oci_identity_compartment.workload.name),
    format("allow dynamic-group %s to use volume-attachments in compartment %s", oci_identity_dynamic_group.compute.name, oci_identity_compartment.workload.name)
  ]
  defined_tags = {
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
  }
}

resource "oci_identity_policy" "compute_for_agent_runcommand" {
  compartment_id = oci_identity_compartment.workload.id
  description    = "OCI Compute Policy for CloudAgent RunCommand"
  name           = "compute-cloudagent-runcommand-policy"
  statements = [
    format("allow dynamic-group %s to use instance-agent-command-execution-family in compartment %s", oci_identity_dynamic_group.compute.name, oci_identity_compartment.workload.name)
  ]
  defined_tags = {
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
  }
}

resource "oci_identity_policy" "compute_for_agent_logmoni" {
  compartment_id = oci_identity_compartment.workload.id
  description    = "OCI Compute Policy for CloudAgent Custom Log Monitoring"
  name           = "compute-cloudagent-log-monitoring-policy"
  statements = [
    format("allow dynamic-group %s to use log-content in compartment %s", oci_identity_dynamic_group.compute.name, oci_identity_compartment.workload.name)
  ]
  defined_tags = {
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
    format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
  }
}
