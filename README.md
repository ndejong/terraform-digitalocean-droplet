# Terraform + Digital Ocean Droplets

Terraform module to create a Digital Ocean Droplet using Terraform with desirable additional features.
 * [Digital Ocean](https://www.digitalocean.com/)
 * [Digital Ocean Terraform Provider](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)

The module is a helpful convenience wrapper around the standard DigitalOcean provider using `cloud-init` 
to provide additional features:-
 * easily remount existing volumes
 * easily create an initial passwordless sudo user directly with sshkeys
 * easily add additional `user_data` scripts to bootstrap the Droplet

## Usage
This module allows you to establish a Droplet on Digital Ocean as shown in the example below:-

```hcl
module "terraform-digitalocean-droplet" {
  source  = "verbnetworks/droplet/digitalocean"

  # required variables
  # ===
  hostname = "awesomehost"
  digitalocean_region = "sgp1"

  # optional variables
  # ===
  initial_user = "ndejong"
  initial_user_sshkeys = [ 
    trimspace(file("~/.ssh/authorized_keys")) 
  ]
  
  user_data = "#cloud-config\npackages:\n - python3"
  
  # digitalocean_volume0 = "[mount-point]:[mount-device]:[volume-id]:[mount-fstype]"
  # digitalocean_volume0 = "/mnt:/dev/disk/by-id/scsi-0DO_Volume_example01:0010c05e-20ad-10e0-9007-00000c113408:ext4"
}

# optional outputs
output "hostname" { value = module.terraform-digitalocean-droplet.hostname }
output "region" { value = module.terraform-digitalocean-droplet.region }
output "ipv4_address" { value = module.terraform-digitalocean-droplet.ipv4_address }
output "volume0" { value = module.terraform-digitalocean-droplet.volume0 }
```

#### Note on Droplet startup
When a Droplet first starts it can take time before the cloudinit scripts complete.  Thus, you may notice in the 
first few minutes when the Droplet starts that the `initial_user` is unable to authenticate.

#### Note on the `digitalocean_volume0` attribute
It is optionally possible to mount a pre-existing volume to your Droplet by providing the mount details in the 
following format `[mount-point]:[mount-device]:[volume-id]:[mount-fstype]`

Obtaining the `[volume-id]` value requires using the Digital Ocean API, you can consider using 
[digitalocean-api-query](https://github.com/verbnetworks/digitalocean-api-query) as a cli tool using a 
"volumes" argument to discover this value.

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
The fact that volumes are not expressed as a list is an implementation detail left for another time.  The issue
is root in the fact that (older) Terraform has limitations in working with lists.  The hard-coded limit of two 
volumes is not ideal but good enough for most situations.

## Versions and testing
The v0.15 `verbnetworks/droplet/digitalocean` module has been tested and is known to with the following
* Terraform versions
  - v0.13.0
  - v0.14.7
* Terraform provider digitalocean/digitalocean versions
  - v2.5.1
* DigitalOcean images
  - ubuntu-20-10-x64, ubuntu-20-04-x64, ubuntu-18-04-x64, ubuntu-16-04-x64
  - centos-8-x64, centos-7-x64
  - fedora-33-x64, fedora-32-x64
  - debian-10-x64, debian-9-x64

The older v0.13 (and prior) `verbnetworks/droplet/digitalocean` versions are compatible with Terraform up to v0.12

****

## Authors
Module managed by
* [Nicholas de Jong](https://github.com/ndejong)

## License
Apache 2 Licensed. See LICENSE for full details.
