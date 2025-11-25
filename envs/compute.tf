resource "oci_core_instance" "oracle_boot_paravirtual" {
  display_name        = "oracle-instance-boot-paravirtual"
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domain.ads.name
  fault_domain        = data.oci_identity_fault_domains.fds.fault_domains[0].name
  shape               = "VM.Standard.E5.Flex"
  shape_config {
    ocpus         = 1
    memory_in_gbs = 12
  }
  instance_options {
    are_legacy_imds_endpoints_disabled = false
  }
  availability_config {
    is_live_migration_preferred = false
    recovery_action             = "RESTORE_INSTANCE"
  }
  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
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
      desired_state = "ENABLED"
      name          = "Cloud Guard Workload Protection"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Block Volume Management"
    }
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
      desired_state = "DISABLED"
      name          = "Compute RDMA GPU Monitoring"
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
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  create_vnic_details {
    display_name = "oracle-instance-boot-paravirtual-vnic"
    subnet_id    = oci_core_subnet.public.id
    nsg_ids = [
      oci_core_network_security_group.sg.id
    ]
    assign_public_ip = true
    hostname_label   = "oracleinstancebootparavirtual"
  }
  is_pv_encryption_in_transit_enabled = true
  source_details {
    source_type                     = "image"
    source_id                       = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaad4k636kt7umtbknxth6izvbhaqpe4fozzjmovmvjyo7zzyvpt33q"
    boot_volume_size_in_gbs         = "60"
    boot_volume_vpus_per_gb         = "10"
    is_preserve_boot_volume_enabled = false
    # kms_key_id                      = null
  }
  # launch_options {
  #   boot_volume_type                    = "PARAVIRTUALIZED"
  #   # firmware                            = "UEFI_64"
  #   is_consistent_volume_naming_enabled = true
  #   is_pv_encryption_in_transit_enabled = true
  #   # network_type                        = "PARAVIRTUALIZED"
  #   # remote_data_volume_type             = "PARAVIRTUALIZED"
  # }
  metadata = {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDccSn9zM/CFZAwXrxR4Gx/7AGXEZ60th7fLHHVFz6EA7S2DFvuoO/y2LXvbpVBDEpbS2aqS/QbE7vNkVEsPlQGUzeWtNy95TWqAYPZgW5vwjxzvmHH8UMN7sDT8bblkiyHFmixf92nhEXUQx32UDCsKWDv4TvKDoue28zXZ8yz01Poz741g0H1BlfOfPbrpl2yjYFuPGScm2NXdEjND8PFVJxIg0GLUpZuxaxPZj8Z92/ROM+g6u3g+ACYR7Vx9NNiG9IP8Du5YJu9wPvi486c4b1R4I0z/yGwodv3h1mmtN9/jQOX6lJRuK2zIIZ+GVIdL+VEyf23h/RWaDbAXD9r ssh-key-2025-11-20"
  }
}
