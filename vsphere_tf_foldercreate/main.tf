terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.0"
    }
  }
}

provider "vsphere" {
  user                 = var.username
  password             = var.password
  vsphere_server       = var.vcenter
  allow_unverified_ssl = true
}

module "folderstructure" {
  source        = "./modules/vsphere-folderstructure"
  parent_folder = var.folderstructure_parent_folder
}

data "vsphere_datacenter" "dc" {
  name = var.dc
}

resource "vsphere_folder" "code2755" {
  path          = "CODE2755"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
