#----------------------------Credentials Variables -------------------------------------------------#

variable "primary_equinix_client_id" {
  description = "Equinix client ID (consumer key), obtained after registering app in the developer platform"
  type        = string
}
variable "primary_equinix_client_secret" {
  description = "Equinix client secret ID (consumer secret), obtained after registering app in the developer platform"
  type        = string
}

variable "auth_token" {
  description = "Equinix client ID (consumer key), obtained after registering app in the developer platform"
  type        = string
}

variable "secondary_equinix_client_id" {
  description = "Equinix client ID (consumer key), obtained after registering app in the developer platform"
  type        = string
}
variable "secondary_equinix_client_secret" {
  description = "Equinix client secret ID (consumer secret), obtained after registering app in the developer platform"
  type        = string
}

#----------------------------Project Variables -------------------------------------------------#

variable "project_id" {
description = "Project ID" 
 type        = string
}


#----------------------------Server Variables -------------------------------------------------#


variable "server1_hostname" {
description = "Server 1 Hostname" 
 type        = string
}

variable "server1_plan" {
description = "Server 1 Plan" 
 type        = string
}

variable "server1_metro" {
description = "Server 1 Metro" 
 type        = string
}


variable "server1_operating_system" {
description = "Server 1 OS" 
 type        = string
}

variable "server1_billing_cycle" {
description = "Server 1 billing" 
 type        = string
}

variable "server2_hostname" {
description = "Server 2 Hostname" 
 type        = string
}

variable "server2_plan" {
description = "Server 2 Plan" 
 type        = string
}

variable "server2_metro" {
description = "Server 2 Metro" 
 type        = string
}


variable "server2_operating_system" {
description = "Server 2 OS" 
 type        = string
}

variable "server2_billing_cycle" {
description = "Server 2 billing" 
 type        = string
}

#----------------------------Network Variables -------------------------------------------------#

variable "metal_notifications_email" {
  description = "Email addresses" 
  type        = string
}


variable "fabric_notifications_emails" {
  description = "Email addresses" 
  type        = list(string)
}


variable "VLAN" {
description = "VLAN ID" 
 type        = string
}



variable "dedicated_port_fabric_uuid" {
description = "Dedicated port fabric UUID" 
 type        = string
}

variable "dedicated_port_interconnection_id" {
description = "Dedicated port Interconnection ID" 
 type        = string
}

variable "dedicated_port_primary_id" {
description = "Dedicated port primary ID" 
 type        = string
}

variable "dedicated_port_nni_vlan_name" {
description = "Dedicated port NNI VLAN name" 
 type        = string
}

