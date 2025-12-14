/************************************************************
Private Key
************************************************************/
resource "tls_private_key" "ssh_keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "private_key" {
  filename        = "./.key/private.pem"
  content         = tls_private_key.ssh_keygen.private_key_pem
  file_permission = "0600"
}

/************************************************************
Compute (Oracle Linux)
************************************************************/
##### Instance
# resource "oci_core_instance" "oracle_instance" {
#   display_name        = "oracle-instance"
#   compartment_id      = oci_identity_compartment.workload.id
#   availability_domain = data.oci_identity_availability_domain.ads.name
#   fault_domain        = data.oci_identity_fault_domains.fds.fault_domains[0].name
#   shape               = "VM.Standard.E5.Flex"
#   shape_config {
#     ocpus         = 1
#     memory_in_gbs = 12
#   }
#   instance_options {
#     are_legacy_imds_endpoints_disabled = false
#   }
#   availability_config {
#     is_live_migration_preferred = false
#     recovery_action             = "RESTORE_INSTANCE"
#   }
#   agent_config {
#     are_all_plugins_disabled = false
#     is_management_disabled   = false
#     is_monitoring_disabled   = false
#     plugins_config {
#       desired_state = "ENABLED"
#       name          = "Custom Logs Monitoring"
#     }
#     plugins_config {
#       desired_state = "ENABLED"
#       name          = "Compute Instance Run Command"
#     }
#     plugins_config {
#       desired_state = "ENABLED"
#       name          = "Compute Instance Monitoring"
#     }
#     plugins_config {
#       desired_state = "ENABLED"
#       name          = "Cloud Guard Workload Protection"
#     }
#     plugins_config {
#       desired_state = "ENABLED"
#       name          = "Block Volume Management"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "WebLogic Management Service"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "Vulnerability Scanning"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "Oracle Java Management Service"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "OS Management Hub Agent"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "Management Agent"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "Fleet Application Management Service"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "Compute RDMA GPU Monitoring"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "Compute HPC RDMA Auto-Configuration"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "Compute HPC RDMA Authentication"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "Bastion"
#     }
#   }
#   create_vnic_details {
#     display_name = "oracle-instance-vnic"
#     subnet_id    = oci_core_subnet.public.id
#     nsg_ids = [
#       oci_core_network_security_group.sg.id
#     ]
#     assign_public_ip = true
#     hostname_label   = "oracle-instance"
#   }
#   is_pv_encryption_in_transit_enabled = true
#   source_details {
#     source_type                     = "image"
#     source_id                       = data.oci_core_images.oracle_supported_image.images[0].id
#     boot_volume_size_in_gbs         = "100"
#     boot_volume_vpus_per_gb         = "10"
#     is_preserve_boot_volume_enabled = false
#     # kms_key_id                      = null
#   }
#   metadata = {
#     ssh_authorized_keys = tls_private_key.ssh_keygen.public_key_openssh
#     user_data           = base64encode(file("./userdata/oracle_init.sh"))
#   }
#   defined_tags = {
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
#     "Compute.CloudAgent"                                                                                                         = "true"
#   }
# }

# ##### TimeWait
# # cloud-init完了に約12分かかるため
# resource "terraform_data" "wait_oracle" {
#   input = oci_core_instance.oracle_instance.id
# }

# resource "time_sleep" "wait_oracle_cloud_init_finish" {
#   depends_on      = [terraform_data.wait_oracle]
#   create_duration = "15m"
# }

# ##### Block Volume
# ### For Paravirtualized
# resource "oci_core_volume" "oracle_volume_para" {
#   depends_on          = [time_sleep.wait_oracle_cloud_init_finish]
#   display_name        = "oracle-volume-paravirtualized"
#   compartment_id      = oci_identity_compartment.workload.id
#   availability_domain = data.oci_identity_availability_domain.ads.name
#   size_in_gbs         = "100"
#   vpus_per_gb         = "10"
#   defined_tags = {
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
#   }
#   is_auto_tune_enabled = true
#   autotune_policies {
#     autotune_type = "DETACHED_VOLUME"
#     # max_vpus_per_gb = null
#   }
#   autotune_policies {
#     autotune_type   = "PERFORMANCE_BASED"
#     max_vpus_per_gb = "20"
#   }
#   is_reservations_enabled = false
#   #   block_volume_replicas_deletion = null
#   #   cluster_placement_group_id     = null
#   #   freeform_tags           = {}
#   #   kms_key_id              = null
#   #   xrc_kms_key_id          = null
#   #   volume_backup_id        = null
# }

# resource "oci_core_volume_attachment" "attach_oracle_volume_para" {
#   attachment_type                     = "paravirtualized"
#   device                              = "/dev/oracleoci/oraclevdb"
#   instance_id                         = oci_core_instance.oracle_instance.id
#   volume_id                           = oci_core_volume.oracle_volume_para.id
#   is_pv_encryption_in_transit_enabled = true
#   display_name                        = "attach-oracle-volume-paravirtualized"
#   is_read_only                        = false
#   is_shareable                        = false
# }

# ### For ISCSI (Attach by Agent)
# resource "oci_core_volume" "oracle_volume_iscsi_by_agent" {
#   depends_on          = [time_sleep.wait_oracle_cloud_init_finish]
#   display_name        = "oracle-volume-iscsi-by-agent"
#   compartment_id      = oci_identity_compartment.workload.id
#   availability_domain = data.oci_identity_availability_domain.ads.name
#   size_in_gbs         = "100"
#   vpus_per_gb         = "10"
#   defined_tags = {
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
#   }
#   is_auto_tune_enabled = true
#   autotune_policies {
#     autotune_type = "DETACHED_VOLUME"
#     # max_vpus_per_gb = null
#   }
#   autotune_policies {
#     autotune_type   = "PERFORMANCE_BASED"
#     max_vpus_per_gb = "20"
#   }
#   is_reservations_enabled = false
#   #   block_volume_replicas_deletion = null
#   #   cluster_placement_group_id     = null
#   #   freeform_tags           = {}
#   #   kms_key_id              = null
#   #   xrc_kms_key_id          = null
#   #   volume_backup_id        = null
# }

# resource "oci_core_volume_attachment" "attach_oracle_volume_iscsi_by_agent" {
#   attachment_type                   = "iscsi"
#   device                            = "/dev/oracleoci/oraclevdc"
#   instance_id                       = oci_core_instance.oracle_instance.id
#   volume_id                         = oci_core_volume.oracle_volume_iscsi_by_agent.id
#   encryption_in_transit_type        = "NONE"
#   display_name                      = "attach-oracle-volume-iscsi-by-agent"
#   is_agent_auto_iscsi_login_enabled = true
#   use_chap                          = true
#   is_read_only                      = false
#   is_shareable                      = false
# }

# ### For ISCSI (Attach by Command)
# resource "oci_core_volume" "oracle_volume_iscsi_by_command" {
#   depends_on          = [time_sleep.wait_oracle_cloud_init_finish]
#   display_name        = "oracle-volume-iscsi-by-command"
#   compartment_id      = oci_identity_compartment.workload.id
#   availability_domain = data.oci_identity_availability_domain.ads.name
#   size_in_gbs         = "100"
#   vpus_per_gb         = "10"
#   defined_tags = {
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
#   }
#   is_auto_tune_enabled = true
#   autotune_policies {
#     autotune_type = "DETACHED_VOLUME"
#     # max_vpus_per_gb = null
#   }
#   autotune_policies {
#     autotune_type   = "PERFORMANCE_BASED"
#     max_vpus_per_gb = "20"
#   }
#   is_reservations_enabled = false
#   #   block_volume_replicas_deletion = null
#   #   cluster_placement_group_id     = null
#   #   freeform_tags           = {}
#   #   kms_key_id              = null
#   #   xrc_kms_key_id          = null
#   #   volume_backup_id        = null
# }

# resource "oci_core_volume_attachment" "attach_oracle_volume_iscsi_by_command" {
#   attachment_type                   = "iscsi"
#   device                            = "/dev/oracleoci/oraclevdd"
#   instance_id                       = oci_core_instance.oracle_instance.id
#   volume_id                         = oci_core_volume.oracle_volume_iscsi_by_command.id
#   encryption_in_transit_type        = "NONE"
#   display_name                      = "attach-oracle-volume-iscsi-by-command"
#   is_agent_auto_iscsi_login_enabled = false
#   use_chap                          = true
#   is_read_only                      = false
#   is_shareable                      = false
# }

# resource "terraform_data" "remote_exec_oracle_iscsi" {
#   depends_on = [
#     time_sleep.wait_oracle_cloud_init_finish,
#     oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command
#   ]
#   provisioner "remote-exec" {
#     connection {
#       agent       = false
#       timeout     = "5m"
#       host        = oci_core_instance.oracle_instance.public_ip
#       user        = "opc"
#       private_key = tls_private_key.ssh_keygen.private_key_openssh
#     }
#     inline = [
#       "sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.iqn} -p ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.ipv4}:${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.port}",
#       "sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.iqn} -n node.startup -v automatic",
#       "sudo iscsiadm -m node -T ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.iqn} -p ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.ipv4}:${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.port} -o update -n node.session.auth.authmethod -v CHAP",
#       "sudo iscsiadm -m node -T ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.iqn} -p ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.ipv4}:${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.port} -o update -n node.session.auth.username -v ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.chap_username}",
#       "sudo iscsiadm -m node -T ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.iqn} -p ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.ipv4}:${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.port} -o update -n node.session.auth.password -v ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.chap_secret}",
#       "sudo iscsiadm -m node -T ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.iqn} -p ${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.ipv4}:${oci_core_volume_attachment.attach_oracle_volume_iscsi_by_command.port} -l",
#     ]
#   }
# }