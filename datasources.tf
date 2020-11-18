## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


# Gets a list of Availability Domains
data "oci_identity_availability_domain" "AD" {
  compartment_id = "${var.tenancy_ocid}"
  ad_number      = "1"
}
data "oci_identity_availability_domain" "AD2" {
  compartment_id = "${var.tenancy_ocid}"
  ad_number      = "2"
}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = "${var.tenancy_ocid}"
}