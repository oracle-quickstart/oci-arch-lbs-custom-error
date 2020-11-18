## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_core_instance_configuration" "TFInstanceConfiguration" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "TFExampleInstanceConfiguration"

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = "${var.compartment_ocid}"
      ipxe_script    = "ipxeScript"
      shape          = "${var.instance_shape}"
      display_name   = "TFExampleInstanceConfigurationLaunchDetails"

      create_vnic_details {
        assign_public_ip       = true
        display_name           = "TFExampleInstanceConfigurationVNIC"
        skip_source_dest_check = false
      }

      extended_metadata = {
        some_string   = "stringA"
        nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
      }

      source_details {
        source_type = "image"
        image_id    = "${var.instance_image_ocid}"
      }
    }
  }
}

resource "oci_core_instance_pool" "TFInstancePool" {
  compartment_id            = "${var.compartment_ocid}"
  instance_configuration_id = "${oci_core_instance_configuration.TFInstanceConfiguration.id}"
  size                      = 2
  state                     = "RUNNING"
  display_name              = "TFInstancePool"

  placement_configurations {
    availability_domain = "${data.oci_identity_availability_domain.AD.name}"
    primary_subnet_id   = "${oci_core_subnet.ExampleSubnet1.id}"
  }
  load_balancers {
        #Required
        backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
        load_balancer_id = "${oci_load_balancer.lb1.id}"
        port = "80"
        vnic_selection = "PrimaryVnic"
    }
}

resource "oci_autoscaling_auto_scaling_configuration" "TFAutoScalingConfiguration" {
  compartment_id       = "${var.compartment_ocid}"
  cool_down_in_seconds = "300"
  display_name         = "TFAutoScalingConfiguration"
  is_enabled           = "true"

  policies {
    capacity {
      initial = "${var.min_instance_count}"
      max     = "${var.max_instance_count}"
      min     = "${var.min_instance_count}"
    }

    display_name = "TFPolicy"
    policy_type  = "threshold"

    rules {
      action {
        type  = "CHANGE_COUNT_BY"
        value = "1"
      }

      display_name = "TFScaleOutRule"

      metric {
        metric_type = "CPU_UTILIZATION"

        threshold {
          operator = "GT"
          value    = "1"
        }
      }
    }

    rules {
      action {
        type  = "CHANGE_COUNT_BY"
        value = "-1"
      }

      display_name = "TFScaleInRule"

      metric {
        metric_type = "CPU_UTILIZATION"

        threshold {
          operator = "LT"
          value    = "1"
        }
      }
    }
  }

  auto_scaling_resources {
    id   = "${oci_core_instance_pool.TFInstancePool.id}"
    type = "instancePool"
  }
}

