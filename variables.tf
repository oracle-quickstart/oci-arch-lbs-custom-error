## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {
}

variable "private_key_path" {
}

variable "fingerprint" {
}

variable "user_ocid"{}

variable "region" {
}

variable "compartment_ocid" {
}

variable "instance_shape" {
  default = "VM.Standard2.1"
}

variable "min_instance_count" {
  default = "2"
}

variable "max_instance_count" {
  default = "3"
}

variable "instance_image_ocid" {
  default = "ocid1.image.oc1.phx.aaaaaaaaoqj42sokaoh42l76wsyhn3k2beuntrh5maj3gmgmzeyr55zzrwwa"
}

# Choose an Availability Domain
variable "availability_domain" {
  default = "3"
}

variable "function_image" {
    default = "phx.ocir.io/jlodinioci/flowlogs/splunk-flow-log-python:0.0.316"
}

variable "application_subnet_ids" {
    default = ["ocid1.subnet.oc1.phx.aaaaaaaalm2ly42yiqq5agcbq53ss6ao6nbqfhjifceo7o2drmh3oxnn5wra"]
}

variable "config" {
  default = {
    "MY_FUNCTION_CONFIG" = "ConfVal"
  }
}