## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_objectstorage_bucket" "maintenance" {
  compartment_id = "${var.compartment_ocid}"
  name           = "${data.oci_identity_tenancy.tenancy.name}_maintenance"
  namespace      = "${data.oci_identity_tenancy.tenancy.name}"
  access_type    = "ObjectRead"
}

resource "oci_objectstorage_object" "maintenance" {
  bucket    = "${oci_objectstorage_bucket.maintenance.name}"
  source    = "content/maintenance.html"
  namespace = "${data.oci_identity_tenancy.tenancy.name}"
  object    = "index.html"
}

resource "oci_objectstorage_object" "function_add_maintenance" {
 bucket    = "${oci_objectstorage_bucket.maintenance.name}"
 source    = "content/add_maintenance.zip"
 namespace = "${data.oci_identity_tenancy.tenancy.name}"
 object    = "add_maintenance.zip"
}

resource "oci_objectstorage_object" "function_remove_maintenance" {
 bucket    = "${oci_objectstorage_bucket.maintenance.name}"
 source    = "content/remove_maintenance.zip"
 namespace = "${data.oci_identity_tenancy.tenancy.name}"
 object    = "remove_maintenance.zip"
}