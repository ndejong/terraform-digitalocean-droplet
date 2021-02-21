# Terraform + Digital Ocean Droplets

Terraform module to create a Digital Ocean Droplet using Terraform with desirable additional features.
 * [Digital Ocean](https://www.digitalocean.com/)
 * [Digital Ocean Terraform Provider](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)

The module is essentially a wrapper around the Digital Ocean provider using a `cloudinit` script to provide additional 
features:-
 * remount existing volumes
 * create an initial user with an sshkey


## Usage
This module allows you to establish a Droplet on Digital Ocean as shown in the example below:-

```hcl
module "terraform-digitalocean-droplet" {
  source  = "verbnetworks/droplet/digitalocean"

  # required variables
  # ===
  hostname = "node08"
  digitalocean_region = "sgp1"

  # optional variables
  # ===
  initial_user = "ndejong"
  initial_user_sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfJI1CKh5EATdGU7ZOPUo1hwQb9Rhk5U4EI9q9JXL2s3zyoVThDkGMx2LZWv+cfRIT2un57tZmbM+S7xNexjWp6S62Fkk1pkVEVEmv4nlVZe4KtzVq8uc8jR6OBiydxrft5zQ1/8XUjZgIX9+kJ5X9YaZTztKAGELHh3gDHMqnt5RpWbqxBd7weiAnRJebTRocr9dnrJvbHkvpc7uiGfMVlILOajg94WxIWHBxNstDUZfZFIPBwiX/Dkk7CKSM+hF0VVPpKXqoWfGCt3QQfUSiK1xp2dpOD4dBtX/fxiEqqq+W4lcPjM2iaN1IVW2iv6vBMUKqkzfLrgsXbdmUkfLp9qTqLsC8JWpdUd8Hm2fDP5DV8RcO4HaXT4FgDrPZVrxRcjYO7iwe0C3PQFhUxQ6AasuAEtLMy38Wi9SLNQPE/KNhQU8U9fHzOUwdQfZDlx8bC8DsOIdwuE4zZYEMvuGmUeR0BgMsq9LPZSdFRKiScEouz9kofPTQ6FYbIVEcXoGpFzG3bU7aIA5CbZWHeVnIcHbiieRmHb2pGHmxuafpTvQCdmezbXanmfy/OhgQahgcH6wuBalsSyHDFoTxDIJEqrlJDpJK4hV//IsSf+QtDqON46mxZrvcStc7erSk6wbbzvPHjLqmWcRcCeTIgWvppLaeTJ+81li6ia0oPqeOBQ== ndejong"
  
  user_data = "#cloud-config\npackages:\n - python3"
  
  # digitalocean_volume0 = "[mount-point]:[mount-device]:[volume-id]:[mount-fstype]"
  # digitalocean_volume0 = "/mnt:/dev/disk/by-id/scsi-0DO_Volume_example01:0010c05e-20ad-10e0-9007-00000c113408:ext4"
}

# optional outputs
output "hostname" { value = "${module.terraform-digitalocean-droplet.hostname}" }
output "region" { value = "${module.terraform-digitalocean-droplet.region}" }
output "ipv4_address" { value = "${module.terraform-digitalocean-droplet.ipv4_address}" }
output "volume0" { value = "${module.terraform-digitalocean-droplet.volume0}" }
```

#### Note on the `digitalocean_volume0` attribute
It is optionally possible to mount a pre-existing volume to your Droplet by providing the mount details in the 
following format `[mount-point]:[mount-device]:[volume-id]:[mount-fstype]`

Obtaining the `[volume-id]` value is not straight-forward through the Digital Ocean web admin user interface and 
requires that you call their API to obtain it.  You can consider using the [digitalocean-api-query](https://github.com/verbnetworks/digitalocean-api-query)
cli tool with the "volumes" argument to discover this value.

```text
$ digitalocean-api-query volumes | jq .volumes
[
  {
    "id": "0010c05e-20ad-10e0-9007-00000c113408",
    "name": "example01",
    "created_at": "2018-03-07T02:12:46Z",
...
```

#### Note on the `digitalocean_volume1` attribute
The fact that volumes are not expressed as a list is an implementation detail left for another time, the hard-coded
and limited `volume0`, `volume1` situation is clearly not ideal but is probably good enough for many situations. 

****


## Input Variables - Required

### hostname
The hostname applied to this strelaysrv-node droplet.

### digitalocean_region
The DigitalOcean region-slug to start this strelaysrv-node within (nyc1, sgp1, lon1, nyc3, ams3, fra1, tor1, sfo2, blr1)


## Input Variables - Optional

### initial_user
The initial user account to create at this digitalocean-droplet - if not root account then the root account will be disabled via sshd_config PermitRootLogin no.
 - default = "root"

### initial_user_sshkeys
The list of ssh authorized_keys values to apply to the initial_user account - the actual ssh public key(s) must be supplied not a reference to an ssh key within a digitalocean account.
 - default = []

### user_data
User supplied cloudinit userdata.
 - default = "#!/bin/sh"

### digitalocean_image
The digitalocean image to use as the base for this digitalocean-droplet
 - default = "ubuntu-20-04-x64"

### digitalocean_size
The size to use for this digitalocean-droplet.
  default = "s-1vcpu-1gb"

### digitalocean_backups
Enable/disable backup functionality on this digitalocean-droplet.
 - default = false

### digitalocean_monitoring
Enable/disable monitoring functionality on this digitalocean-droplet.
 - default = true

### digitalocean_ipv6
Enable/disable getting a public IPv6 on this digitalocean-droplet.
 - default = false

### digitalocean_private_networking
Enable/disable private-networking functionality on this digitalocean-droplet.
 - default = false

### digitalocean_resize_disk
Enable/disable resize-disk functionality on this digitalocean-droplet.
 - default = false

### digitalocean_ssh_keys
A list of Digital Ocean SSH ids or sshkey fingerprints to apply to the root account - overwritten by `initial_user_sshkeys` if `initial_user` is root.
 - default = []

### digitalocean_tags
List of tags to apply to this Droplet, the tags MUST already exist!
 - default = []
 
### digitalocean_volume0
Volume0 to attach to this digitalocean-droplet in the format `[mount-point]:[mount-device]:[volume-id]:[mount-fstype]` - review README for information on discovering the <volume-id> value.
 - default = ""

### digitalocean_volume1
Volume1 to attach to this digitalocean-droplet in the format `[mount-point]:[mount-device]:[volume-id]:[mount-fstype]` - review README for information on discovering the <volume-id> value.
 - default = ""


## Outputs

### hostname
The hostname applied to this digitalocean-droplet.

### region
The digitalocean region-slug this digitalocean-droplet is running in.

### droplet_id
The droplet_id of this digitalocean-droplet.

### ipv4_address
The public IPv4 address of this digitalocean-droplet.

### ipv4_address_private
The private IPv4 address of this digitalocean-droplet.

### ipv6_address
The public IPv6 address of this digitalocean-droplet.

### volume0
Volume0 attached to this digitalocean-droplet in the format `[mount-point]:[mount-device]:[volume-id]:[mount-fstype]`

### volume1
Volume1 attached to this digitalocean-droplet in the format `[mount-point]:[mount-device]:[volume-id]:[mount-fstype]`

****

## Authors
Module managed by
* [Verb Networks](https://github.com/verbnetworks)
* [Nicholas de Jong](https://github.com/ndejong)

## License
Apache 2 Licensed. See LICENSE for full details.
