## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_functions_application" "maintenance" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    display_name = "splunk_flowlogs"
    subnet_ids = "${var.application_subnet_ids}"
}

resource "oci_functions_function" "add_maintenance" {
    #Required
    application_id = "${oci_functions_application.maintenance.id}"
    display_name = "add_maintenance"
    image = "${var.function_image}"
    memory_in_mbs = "1024"
    config = "${var.config}"

}

resource "oci_functions_function" "remove_maintenance" {
    #Required
    application_id = "${oci_functions_application.maintenance.id}"
    display_name = "remove_maintenance"
    image = "${var.function_image}"
    memory_in_mbs = "1024"
    config = "${var.config}"

}