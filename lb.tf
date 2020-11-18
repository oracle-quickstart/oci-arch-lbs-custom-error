## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_load_balancer" "lb1" {
  shape          = "100Mbps"
  compartment_id = "${var.compartment_ocid}"
  subnet_ids = [
    "${oci_core_subnet.ExampleSubnet1.id}",
    "${oci_core_subnet.ExampleSubnet2.id}"
  ]
  display_name = "lb1"
}

resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  policy           = "ROUND_ROBIN"
  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = "${oci_load_balancer.lb1.id}"
  name                     = "http"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
  port                     = 80
  protocol                 = "HTTP"
  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "oci_load_balancer_listener" "maintenance" {
  load_balancer_id         = "${oci_load_balancer.lb1.id}"
  name                     = "http"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
  port                     = 8080
  protocol                 = "HTTP"
  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "oci_load_balancer_backend" "maintenance" {
    #Required
    backendset_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
    ip_address = "${oci_load_balancer.lb1.ip_address_details.1.ip_address}"
    load_balancer_id = "${oci_load_balancer.lb1.id}"
    port = "${oci_load_balancer_listener.maintenance.port}"
    backup = "true"
}

resource "oci_load_balancer_rule_set" "maintenance_rule_set" {
    #Required
    items {
        #Required
        action = "REDIRECT"
        redirect_uri {

            #Optional
            protocol = "HTTPS"
            host     = "in{host}"
            port     = 443
            path     = "${oci_objectstorage_object.maintenance.object}" 
            query    = "{query}"
        }
        response_code = "302"
    }
    load_balancer_id = "${oci_load_balancer.lb1.id}"
    name = "mentenance"
}