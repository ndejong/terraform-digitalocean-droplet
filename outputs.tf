# terraform-digitalocean-droplet
# ============================================================================

# Copyright (c) 2018 Verb Networks Pty Ltd <contact [at] verbnetworks.com>
#  - All rights reserved.
#
# Apache License v2.0
#  - http://www.apache.org/licenses/LICENSE-2.0

# outputs
# ============================================================================

output "hostname" {
  description = "The hostname applied to this digitalocean-droplet."
  value = "${var.hostname}"
}

output "region" {
  description = "The digitalocean region-slug this digitalocean-droplet is running in."
  value = "${var.digitalocean_region}"
}

output "droplet_id" {
  description = "The droplet_id of this digitalocean-droplet."
  value = "${digitalocean_droplet.droplet.id}"
}

output "ipv4_address" {
  description = "The public IPv4 address of this digitalocean-droplet."
  value = "${digitalocean_droplet.droplet.ipv4_address}"
}

//
// Requires the latest Digital Ocean provider to access these attributes:-
//  - ipv4_address_private
//  - ipv6_address
//  - ipv6_address_private
//
// you may need to perform a `terraform init -upgrade` to get the latest Digital Ocean provider
//

output "ipv4_address_private" {
  description = "The private IPv4 address of this digitalocean-droplet."
  value = "${digitalocean_droplet.droplet.ipv4_address_private}"
}

output "ipv6_address" {
  description = "The public IPv6 address of this digitalocean-droplet."
  value = "${digitalocean_droplet.droplet.ipv6_address}"
}

output "ipv6_address_private" {
  description = "The private IPv6 address of this digitalocean-droplet."
  value = "${digitalocean_droplet.droplet.ipv6_address_private}"
}

output "volume0" {
  description = "Volume0 attached to this digitalocean-droplet in the format <mount-point>:<mount-device>:<volume-id>:<mount-fstype>"
  value = "${var.digitalocean_volume0}"
}

output "volume1" {
  description = "Volume1 attached to this digitalocean-droplet in the format <mount-point>:<mount-device>:<volume-id>:<mount-fstype>"
  value = "${var.digitalocean_volume1}"
}
