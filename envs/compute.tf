resource "oci_core_instance" "oracle" {
  compartment_id      = "ocid1.compartment.oc1..aaaaaaaao7es4oejvbuffragkycdcgrjyb3rh4cms5hwhnmwvzrooa7wbgsa"
  display_name        = "instance-20251120-1518"
  availability_domain = "xFcd:AP-TOKYO-1-AD-1"
  fault_domain        = "FAULT-DOMAIN-1"
  shape               = "VM.Standard.E5.Flex"
  metadata = {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDccSn9zM/CFZAwXrxR4Gx/7AGXEZ60th7fLHHVFz6EA7S2DFvuoO/y2LXvbpVBDEpbS2aqS/QbE7vNkVEsPlQGUzeWtNy95TWqAYPZgW5vwjxzvmHH8UMN7sDT8bblkiyHFmixf92nhEXUQx32UDCsKWDv4TvKDoue28zXZ8yz01Poz741g0H1BlfOfPbrpl2yjYFuPGScm2NXdEjND8PFVJxIg0GLUpZuxaxPZj8Z92/ROM+g6u3g+ACYR7Vx9NNiG9IP8Du5YJu9wPvi486c4b1R4I0z/yGwodv3h1mmtN9/jQOX6lJRuK2zIIZ+GVIdL+VEyf23h/RWaDbAXD9r ssh-key-2025-11-20"
  }
  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
    plugins_config {
      desired_state = "DISABLED"
      name          = "WebLogic Management Service"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Oracle Java Management Service"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "OS Management Hub Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Fleet Application Management Service"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute RDMA GPU Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Run Command"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Auto-Configuration"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Authentication"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Cloud Guard Workload Protection"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  availability_config {
    is_live_migration_preferred = false
    recovery_action             = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    assign_ipv6ip             = false
    assign_private_dns_record = false
    assign_public_ip          = "true"
    defined_tags = {
      "Oracle-Tags.CreatedBy" = "dev-admin/taifumalu+oci-dev-admin@gmail.com"
      "Oracle-Tags.CreatedOn" = "2025-11-20T06:20:05.667Z"
    }
    display_name   = "instance-20251120-1518"
    hostname_label = "test"
    nsg_ids        = ["ocid1.networksecuritygroup.oc1.ap-tokyo-1.aaaaaaaaqns3xvwwh6xo7nfjknftpta62oqi2soae2jqzktw55rs4nkusvyq"]
    subnet_id      = "ocid1.subnet.oc1.ap-tokyo-1.aaaaaaaankxwi2nfkwlkytcaiftiqtev5pnibluile35szi5akayrdb76jfq"
  }
  instance_options {
    are_legacy_imds_endpoints_disabled = false
  }
  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = true
    is_pv_encryption_in_transit_enabled = true
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }
  platform_config {
    are_virtual_instructions_enabled               = false
    config_map                                     = {}
    is_access_control_service_enabled              = false
    is_input_output_memory_management_unit_enabled = false
    is_measured_boot_enabled                       = false
    is_memory_encryption_enabled                   = false
    is_secure_boot_enabled                         = false
    is_symmetric_multi_threading_enabled           = true
    is_trusted_platform_module_enabled             = false
    numa_nodes_per_socket                          = null
    percentage_of_cores_enabled                    = 0
    type                                           = "AMD_VM"
  }
  shape_config {
    baseline_ocpu_utilization = null
    memory_in_gbs             = 12
    nvmes                     = 0
    ocpus                     = 1
    resource_management       = null
    vcpus                     = 2
  }
  source_details {
    boot_volume_size_in_gbs         = "60"
    boot_volume_vpus_per_gb         = "10"
    is_preserve_boot_volume_enabled = false
    kms_key_id                      = null
    source_id                       = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaad4k636kt7umtbknxth6izvbhaqpe4fozzjmovmvjyo7zzyvpt33q"
    source_type                     = "image"
  }
}
