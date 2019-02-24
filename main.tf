# terraform-digitalocean-droplet
# ============================================================================

# Copyright (c) 2018 Verb Networks Pty Ltd <contact [at] verbnetworks.com>
#  - All rights reserved.
#
# Apache License v2.0
#  - http://www.apache.org/licenses/LICENSE-2.0

# Render the required userdata
# ===
data "template_file" "droplet-bootstrap-sh" {
  template = "${file("${path.module}/data/droplet-bootstrap.sh")}"
  vars {

    # volume0
    volume0_dev = "${element(split(":", var.digitalocean_volume0),1)}"
    volume0_mount = "${element(split(":", var.digitalocean_volume0),0)}"
    volume0_fstype = "${element(split(":", var.digitalocean_volume0),3)}"

    # volume1
    volume1_dev = "${element(split(":", var.digitalocean_volume1),1)}"
    volume1_mount = "${element(split(":", var.digitalocean_volume1),0)}"
    volume1_fstype = "${element(split(":", var.digitalocean_volume1),3)}"

    initial_user = "${var.initial_user}"
    initial_user_sshkeys = "${join("\n", var.initial_user_sshkeys)}"

  }
}

# create the cloudinit user-data string to apply to this droplet
# ===
data "template_cloudinit_config" "droplet-userdata" {

  # NB: some kind of cloud-init issue prevents gzip+base64 from working with digitalocean, we (mostly) work around this
  # by wrapping via " echo -n | base64 -d | gunzip | /bin/sh" style pipe chain as per below
  # ===
  gzip = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename = "10-terraform-bootstrap"
    content = "#!/bin/sh\necho -n '${base64gzip(data.template_file.droplet-bootstrap-sh.rendered)}' | base64 -d | gunzip | /bin/sh"
  }

  part {
    content = "${var.user_data}"
    filename = "20-userdata-bootstrap"
  }
}

# Establish the digitalocean_droplet
# ===
resource "digitalocean_droplet" "droplet" {
  image = "${var.digitalocean_image}"
  name = "${var.hostname}"
  region = "${var.digitalocean_region}"
  size = "${var.digitalocean_size}"
  backups = "${var.digitalocean_backups}"
  monitoring = "${var.digitalocean_monitoring}"
  ipv6 = "${var.digitalocean_ipv6}"
  private_networking = "${var.digitalocean_private_networking}"
  ssh_keys = "${var.digitalocean_ssh_keys}"
  resize_disk = "${var.digitalocean_resize_disk}"
  tags = "${var.digitalocean_tags}"
  user_data = "${data.template_cloudinit_config.droplet-userdata.rendered}"
  volume_ids = [ "${element(split(":", var.digitalocean_volume0),2)}", "${element(split(":", var.digitalocean_volume1),2)}" ]
}
