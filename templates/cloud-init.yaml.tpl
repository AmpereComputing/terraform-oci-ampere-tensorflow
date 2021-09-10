#cloud-config

apt:
  sources:
    docker.list:
      source: deb [arch=arm64] https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88

package_update: true
package_upgrade: true

packages:
  - docker-ce
  - docker-ce-cli
  - python3-pip
  - docker-compose

groups:
  - docker
system_info:
  default_user:
    groups: [docker]

runcmd:
  - echo 'OCI Ampere Tensorflow provided by Terraform.' >> /etc/motd
