data "vsphere_datacenter" "dc" {
  name = var.vsphere_dc
}

resource "vsphere_resource_pool" "dev" {
  name          = "${var.vsphere_cluster}/Resources/${var.vsphere_rp}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_datastore" "vsan" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_datastore" "vmnet" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_folder" "dev_folder" {
  path = var.folder_name
}

resource "vsphere_virtual_machine" "dev_vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_resource_pool.wkld.id
  datastore_id     = data.vsphere_datastore.vsan.id
  folder           = data.vsphere_folder.dev_folder.path

  num_cpus                   = var.vm_cpus
  memory                     = var.vm_memory
  guest_id                   = "centos6Guest"
  wait_for_guest_net_timeout = 0

  disk {
    label = "disk0"
    size  = 20
  }

  network_interface {
    network_id = data.vsphere_network.vmnet.id
  }
}
