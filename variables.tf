# terraform-digitalocean-droplet
# ============================================================================

# Copyright (c) 2021 Verb Networks Pty Ltd <contact [at] verbnetworks.com>
#  - All rights reserved.
#
# Apache License v2.0
#  - http://www.apache.org/licenses/LICENSE-2.0


# variables - required
# ============================================================================

variable "digitalocean_image" {
  description = "The DigitalOcean image to use as the base for this digitalocean-droplet."
  #default = "ubuntu-20-10-x64"    # tested 2021-02-21 :: digitalocean v2.5.1; terraform v0.14.7; terraform v0.13.0
  default = "ubuntu-20-04-x64"    # tested 2021-02-21 :: digitalocean v2.5.1; terraform v0.14.7; terraform v0.13.0
  #default = "ubuntu-18-04-x64"    # tested 2021-02-21 :: digitalocean v2.5.1; terraform v0.14.7
  #default = "ubuntu-16-04-x64"    # tested 2021-02-21 :: digitalocean v2.5.1; terraform v0.14.7
  #default = "centos-8-x64"        # tested 2021-02-21 :: digitalocean v2.5.1; terraform v0.14.7; terraform v0.13.0
  #default = "centos-7-x64"        # tested 2021-02-21 :: digitalocean v2.5.1; terraform v0.14.7
  #default = "fedora-33-x64"       # tested 2021-02-21 :: digitalocean v2.5.1; terraform v0.14.7; terraform v0.13.0
  #default = "fedora-32-x64"       # tested 2021-02-21 :: digitalocean v2.5.1; terraform v0.14.7
  #default = "debian-10-x64"       # tested 2021-02-21 :: digitalocean v2.5.1; terraform v0.14.7; terraform v0.13.0
  #default = "debian-9-x64"        # tested 2021-02-21 :: digitalocean v2.5.1; terraform v0.14.7
}

variable "hostname" {
  description = "The hostname applied to this DigitalOcean Droplet."
}

variable "digitalocean_region" {
  description = "The DigitalOcean region-slug to start this digitalocean-droplet within (ams2, ams3, blr1, fra1, lon1, nyc1, nyc2, nyc3, sfo1, sfo2, sfo3, sgp1, tor1)"
}

variable "digitalocean_size" {
  description = "The DigitalOcean Droplet size to use for this digitalocean-droplet."
  default = "s-1vcpu-1gb"
}

# variables - optional
# ============================================================================

variable "initial_user" {
  description = "The initial user account to create at this DigitalOcean Droplet.  If not root account then the root account will be disabled via sshd_config PermitRootLogin no."
  default = "root"
}

variable "initial_user_sshkeys" {
  type = list(string)
  description = "The list of ssh authorized_keys values to apply to the initial_user account. The actual ssh public key(s) must be supplied not an ID reference to the key within DigitalOcean."
  default = []
}

variable "digitalocean_backups" {
  description = "Enable/disable backup functionality on this DigitalOcean Droplet."
  default = false
}

variable "digitalocean_monitoring" {
  description = "Enable/disable monitoring functionality on this DigitalOcean Droplet."
  default = true
}

variable "digitalocean_ipv6" {
  description = "Enable/disable getting a public IPv6 on this DigitalOcean Droplet."
  default = false
}

variable "digitalocean_vpc_uuid" {
  description = "The ID of the VPC where this DigitalOcean Droplet will be located."
  default = null
}

variable "digitalocean_private_networking" {
  description = "Enable/disable private-networking functionality on this DigitalOcean Droplet."
  default = false
}

variable "digitalocean_ssh_keys" {
  type = list(string)
  description = "A list of DigitalOcean SSH ids (or sshkey fingerprints) to apply to the root account;  NB: this is overwritten by `initial_user_sshkeys` if `initial_user` is root."
  default = []
}

variable "digitalocean_resize_disk" {
  description = "Enable/disable resize-disk functionality on this DigitalOcean Droplet."
  default = false
}

variable "digitalocean_tags" {
  type = list(string)
  description = "List of tags to apply to this DigitalOcean Droplet."
  default = []
}

variable "user_data" {
  description = "User supplied cloudinit userdata."
  default = "#!/bin/sh"
}

variable "digitalocean_volume0" {
  description = "Volume0 to attach to this DigitalOcean Droplet in the format <mount-point>:<mount-device>:<volume-id>:<mount-fstype> - review README for information on discovering the <volume-id> value."

  #
  # example value:
  #   digitalocean_volume0 = "/mnt:/dev/disk/by-id/scsi-0DO_Volume_example01:0010c05e-20ad-10e0-9007-00000c113408:ext4"
  #
  # helpful cli tool to discover the <volume-id> value - use the "volumes" argument:
  #   https://github.com/verbnetworks/digitalocean-api-query
  #

  default = ""
}

variable "digitalocean_volume1" {
  description = "Volume1 to attach to this digitalocean-droplet in the format <mount-point>:<mount-device>:<volume-id>:<mount-fstype> - review README for information on discovering the <volume-id> value."
  default = ""
}
