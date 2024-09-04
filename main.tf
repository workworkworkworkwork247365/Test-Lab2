//create 1st server in metro 1 and configure bond and IP 

resource "equinix_metal_device" "server_1" {
  hostname         = var.server1_hostname
  plan             = var.server1_plan
  metro            = var.server1_metro
  operating_system = var.server1_operating_system
  billing_cycle    = var.server1_billing_cycle
  project_id       = var.project_id

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("privatekey.pem")  
    host        = self.access_public_ipv4
  }

  provisioner "remote-exec" {
    inline = [
      "ip link add link bond0 name bond0.227 type vlan id 227",
      "ip addr add 172.16.10.3/24 dev bond0.227",
      "ip link set dev bond0.227 up",
    ]
  }

}


//create 2nd server in metro 2 and configure bond and IP 

resource "equinix_metal_device" "server_2" {
  hostname         = var.server2_hostname
  plan             = var.server2_plan
  metro            = var.server2_metro
  operating_system = var.server2_operating_system
  billing_cycle    = var.server2_billing_cycle
  project_id       = var.project_id

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("privatekey.pem")  
    host        = self.access_public_ipv4
  }

  provisioner "remote-exec" {
    inline = [
      "ip link add link bond0 name bond0.227 type vlan id 227",
      "ip addr add 172.16.10.4/24 dev bond0.227",
      "ip link set dev bond0.227 up",
    ]
  }
}


//create vlan for metro 1 

resource "equinix_metal_vlan" "vlan-metro_1" {
  metro       = var.server1_metro
  project_id  = var.project_id
  vxlan = var.VLAN
}
 
//create vlan for metro 2
resource "equinix_metal_vlan" "vlan-metro_2" {
  metro       = var.server2_metro
  project_id  = var.project_id
  vxlan = var.VLAN
}


//attach vlan in metro1 to server1  

resource "equinix_metal_port_vlan_attachment" "vlan_attachment_DA" {
  device_id = equinix_metal_device.server_1.id
  port_name   = "bond0"
  vlan_vnid = equinix_metal_vlan.vlan-metro_1.vxlan
}
 
//attach vlan in metro2 to server2  

resource "equinix_metal_port_vlan_attachment" "vlan_attachment_NY" {
  device_id = equinix_metal_device.server_2.id
  port_name   = "bond0"
  vlan_vnid = equinix_metal_vlan.vlan-metro_2.vxlan
}
 
//convert server1 to hybridbonded 

resource "equinix_metal_device_network_type" "set_hybrid_bonded_DA" {
  device_id = equinix_metal_device.server_1.id
  type = "hybrid-bonded"
}
 

//convert server2 to hybridbonded 

resource "equinix_metal_device_network_type" "set_hybrid_bonded_NY" {
  device_id = equinix_metal_device.server_2.id
  type = "hybrid-bonded"
}
 

//create fabric billed token interconnection from metro 2

resource "equinix_metal_connection" "fabric_billed_interconnection" {
  provider = equinix.primary
    name               = "fabric_billed_interconnection"
    project_id         = var.project_id
    type               = "shared"
    redundancy         = "primary"
    metro              = "NY"
    speed              = "10Gbps"
    service_token_type = "z_side"
    contact_email      = var.metal_notifications_email
    vlans              = [
      equinix_metal_vlan.vlan-metro_2.vxlan
    ]
}


//consume token and create connection from dedicated port in metro1

resource "equinix_fabric_connection" "dedicatedport2token" {
  provider = equinix.secondary
  name = "Dedicatedp-sharedp-VC"
  type = "EVPL_VC"
  notifications {
    type   = "ALL"
    emails = var.fabric_notifications_emails
  }
  bandwidth = 50

  a_side {
    access_point {
      type= "COLO"
      port {
        uuid = var.dedicated_port_fabric_uuid
      }
      link_protocol {
        type = "DOT1Q"
        vlan_tag = var.VLAN
      }
    }
  }
  z_side {
    service_token {
      uuid = equinix_metal_connection.fabric_billed_interconnection.service_tokens.0.id
    }
  }
}

//associate VLAN to (primary) dedicated port"

resource "equinix_metal_virtual_circuit" "nni_vlan_attachment" {
  connection_id = var.dedicated_port_interconnection_id 
  project_id   = var.project_id
  port_id = var.dedicated_port_primary_id 
  vlan_id = equinix_metal_vlan.vlan-metro_1.id
  nni_vlan = equinix_metal_vlan.vlan-metro_1.vxlan
  name = var.dedicated_port_nni_vlan_name
}



