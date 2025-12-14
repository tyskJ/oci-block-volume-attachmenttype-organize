/************************************************************
PW
************************************************************/
resource "random_string" "instance_password" {
  length  = 16
  special = true
}

/************************************************************
Cloud-Init
************************************************************/
data "cloudinit_config" "this" {
  gzip          = false
  base64_encode = true
  part {
    filename     = "windows_init.ps1"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/userdata/windows_init.ps1", {
      instance_user     = "opc"
      instance_password = random_string.instance_password.result
    })
  }
  # part {
  #   filename     = "windows_admin.yml"
  #   content_type = "text/cloud-config"
  #   content      = file("${path.module}/userdata/windows_admin.yml")
  # }
}

/************************************************************
Compute (Windows Server)
************************************************************/
##### Instance
# resource "oci_core_instance" "windows_instance" {
#   display_name        = "windows-instance"
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
#       name          = "Vulnerability Scanning"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "OS Management Hub Agent"
#     }
#     plugins_config {
#       desired_state = "DISABLED"
#       name          = "Fleet Application Management Service"
#     }
#   }
#   create_vnic_details {
#     display_name = "windows-instance-vnic"
#     subnet_id    = oci_core_subnet.public.id
#     nsg_ids = [
#       oci_core_network_security_group.sg.id
#     ]
#     assign_public_ip = true
#     hostname_label   = "windows-instance"
#   }
#   is_pv_encryption_in_transit_enabled = true
#   source_details {
#     source_type                     = "image"
#     source_id                       = data.oci_core_images.windows_supported_image.images[0].id
#     boot_volume_size_in_gbs         = "100"
#     boot_volume_vpus_per_gb         = "10"
#     is_preserve_boot_volume_enabled = false
#     # kms_key_id                      = null
#   }
#   metadata = {
#     user_data = data.cloudinit_config.this.rendered
#   }
#   defined_tags = {
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_env.tag_definition_name)                = "prd"
#     format("%s.%s", oci_identity_tag_namespace.common.name, oci_identity_tag_default.key_managedbyterraform.tag_definition_name) = "true"
#     "Compute.CloudAgent"                                                                                                         = "true"
#   }
# }

# # ##### TimeWait
# # resource "terraform_data" "wait_windows" {
# #   input = oci_core_instance.windows_instance.id
# # }

# # resource "time_sleep" "wait_windows_cloud_init_finish" {
# #   depends_on      = [terraform_data.wait_windows]
# #   create_duration = "5m"
# # }

# ##### Block Volume
# ### For Paravirtualized
# resource "oci_core_volume" "windows_volume_para" {
#   depends_on          = [time_sleep.wait_windows_cloud_init_finish]
#   display_name        = "windows-volume-paravirtualized"
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

# resource "oci_core_volume_attachment" "attach_windows_volume_para" {
#   attachment_type                     = "paravirtualized"
#   instance_id                         = oci_core_instance.windows_instance.id
#   volume_id                           = oci_core_volume.windows_volume_para.id
#   is_pv_encryption_in_transit_enabled = true
#   display_name                        = "attach-windows-volume-paravirtualized"
#   is_read_only                        = false
#   is_shareable                        = false
# }

# ### For ISCSI (Attach by Agent)
# resource "oci_core_volume" "windows_volume_iscsi_by_agent" {
#   # depends_on          = [time_sleep.wait_windows_cloud_init_finish]
#   display_name        = "windows-volume-iscsi-by-agent"
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

# resource "oci_core_volume_attachment" "attach_windows_volume_iscsi_by_agent" {
#   attachment_type                   = "iscsi"
#   instance_id                       = oci_core_instance.windows_instance.id
#   volume_id                         = oci_core_volume.windows_volume_iscsi_by_agent.id
#   encryption_in_transit_type        = "NONE"
#   display_name                      = "attach-windows-volume-iscsi-by-agent"
#   is_agent_auto_iscsi_login_enabled = true
#   use_chap                          = true
#   is_read_only                      = false
#   is_shareable                      = false
# }

# resource "terraform_data" "remote_exec_windows_iscsi_by_agent" {
#   depends_on = [
#     # time_sleep.wait_windows_cloud_init_finish,
#     oci_core_volume_attachment.attach_windows_volume_iscsi_by_agent
#   ]
#   provisioner "remote-exec" {
#     connection {
#       type     = "winrm"
#       timeout  = "5m"
#       host     = oci_core_instance.windows_instance.public_ip
#       user     = "opc"
#       password = random_string.instance_password.result
#       https    = true
#       port     = 5986
#       insecure = true
#     }
#     inline = [
#       "iscsicli.exe QLoginTarget ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_agent.iqn} ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_agent.chap_username} ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_agent.chap_secret}",
#       "iscsicli.exe PersistentLoginTarget ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_agent.iqn} * ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_agent.ipv4} ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_agent.port} * * * 0x8 * * * * * ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_agent.chap_username} ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_agent.chap_secret} 1 * *",
#     ]
#   }
# }

# ### For ISCSI (Attach by Command)
# resource "oci_core_volume" "windows_volume_iscsi_by_command" {
#   # depends_on          = [time_sleep.wait_windows_cloud_init_finish]
#   display_name        = "windows-volume-iscsi-by-command"
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

# resource "oci_core_volume_attachment" "attach_windows_volume_iscsi_by_command" {
#   attachment_type                   = "iscsi"
#   instance_id                       = oci_core_instance.windows_instance.id
#   volume_id                         = oci_core_volume.windows_volume_iscsi_by_command.id
#   encryption_in_transit_type        = "NONE"
#   display_name                      = "attach-windows-volume-iscsi-by-command"
#   is_agent_auto_iscsi_login_enabled = false
#   use_chap                          = true
#   is_read_only                      = false
#   is_shareable                      = false
# }

# resource "terraform_data" "remote_exec_windows_iscsi_by_command" {
#   depends_on = [
#     # time_sleep.wait_windows_cloud_init_finish,
#     oci_core_volume_attachment.attach_windows_volume_iscsi_by_agent,
#     terraform_data.remote_exec_windows_iscsi_by_agent,
#     oci_core_volume_attachment.attach_windows_volume_iscsi_by_command
#   ]
#   provisioner "remote-exec" {
#     connection {
#       type     = "winrm"
#       timeout  = "5m"
#       host     = oci_core_instance.windows_instance.public_ip
#       user     = "opc"
#       password = random_string.instance_password.result
#       https    = true
#       port     = 5986
#       insecure = true
#     }
#     inline = [
#       "iscsicli.exe QAddTargetPortal ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_command.ipv4}",
#       "iscsicli.exe QLoginTarget ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_command.iqn} ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_command.chap_username} ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_command.chap_secret}",
#       "iscsicli.exe PersistentLoginTarget ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_command.iqn} * ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_command.ipv4} ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_command.port} * * * 0x8 * * * * * ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_command.chap_username} ${oci_core_volume_attachment.attach_windows_volume_iscsi_by_command.chap_secret} 1 * *",
#     ]
#   }
# }