# terraform-digitalocean-droplet
# ============================================================================

# Copyright (c) 2018 Verb Networks Pty Ltd <contact [at] verbnetworks.com>
#  - All rights reserved.
#
# Apache License v2.0
#  - http://www.apache.org/licenses/LICENSE-2.0


# required variables
# ============================================================================

variable "hostname" {
  description = "The hostname applied to this digitalocean-droplet."
}

variable "digitalocean_region" {
  description = "The DigitalOcean region-slug to start this digitalocean-droplet within (nyc1, sgp1, lon1, nyc3, ams3, fra1, tor1, sfo2, blr1)"
}

# variables - with defined defaults
# ============================================================================

variable "initial_user" {
  description = "The initial user account to create at this digitalocean-droplet - if not root account then the root account will be disabled via sshd_config PermitRootLogin no."
  default = "root"
}

variable "initial_user_sshkeys" {
  type = "list"
  description = "The list of ssh authorized_keys values to apply to the initial_user account - the actual ssh public key(s) must be supplied not a reference to an ssh key within a digitalocean account."
  default = []
}

variable "digitalocean_image" {
  description = "The digitalocean image to use as the base for this digitalocean-droplet."
  default = "ubuntu-18-04-x64"    # tested and confirmed 2018-07-18
  # default = "ubuntu-17-10-x64"  # tested and confirmed 2018-03-29, 2018-07-18
  # default = "ubuntu-16-04-x64"  # tested and confirmed 2018-03-29, 2018-07-18
}

variable "digitalocean_size" {
  description = "The digitalocean droplet size to use for this digitalocean-droplet."

  #
  # reference:
  #   https://www.digitalocean.com/docs/release-notes/2018/droplet-bandwidth-billing/
  #
  # helpful cli tool to discover digitalocean droplet size values - use the "regions" argument:
  #   https://github.com/verbnetworks/digitalocean-api-query
  #

  default = "s-1vcpu-1gb"
}

variable "digitalocean_backups" {
  description = "Enable/disable backup functionality on this digitalocean-droplet."
  default = false
}

variable "digitalocean_monitoring" {
  description = "Enable/disable monitoring functionality on this digitalocean-droplet."
  default = true
}

variable "digitalocean_ipv6" {
  description = "Enable/disable getting a public IPv6 on this digitalocean-droplet."
  default = false
}

variable "digitalocean_private_networking" {
  description = "Enable/disable private-networking functionality on this digitalocean-droplet."
  default = false
}

variable "digitalocean_resize_disk" {
  description = "Enable/disable resize-disk functionality on this digitalocean-droplet."
  default = false
}

# variables - optional
# ============================================================================
variable "user_data" {
  description = "User supplied cloudinit userdata."
  default = "#!/bin/sh"
}

variable "digitalocean_ssh_keys" {
  type = "list"
  description = "A list of Digital Ocean SSH ids or sshkey fingerprints to apply to the root account - overwritten by `initial_user_sshkeys` if `initial_user` is root."
  default = []
}

variable "digitalocean_tags" {
  type = "list"
  description = "List of tags to apply to this Droplet, these tags MUST already exist!"
  default = []
}

variable "digitalocean_volume0" {
  description = "Volume0 to attach to this digitalocean-droplet in the format <mount-point>:<mount-device>:<volume-id>:<mount-fstype> - review README for information on discovering the <volume-id> value."

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
