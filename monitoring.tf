## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_monitoring_alarm" "alarm" {
  #Required
 compartment_id        = "${var.compartment_ocid}"
 destinations          = ["${oci_ons_notification_topic.lb_health_topic.id}"]
 display_name          = "lb_health_topic"
 is_enabled            = "true"
 metric_compartment_id = "${var.compartment_ocid}"
 namespace             = "oci_lbaas"
 query                 = "UnHealthyBackendServers[1m]{lbComponent = \\"Backendset\\", resourceId = \\"${oci_load_balancer.lb1.id}\\", backendSetName = \\\"${oci_load_balancer_backend_set.lb-bes1.name}\\\"}.count() > ${var.min_instance_count}"
 severity              = "CRITICAL"
}

resource "random_string" "topicname" {
  length  = 10
  special = false
}

resource "oci_ons_notification_topic" "lb_health_topic" {
#  #Required
  compartment_id = "${var.compartment_ocid}"
  name           = "${random_string.topicname.result}"
}