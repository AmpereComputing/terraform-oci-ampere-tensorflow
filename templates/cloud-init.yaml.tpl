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


write_files:
  - path: /opt/onspecta/docker-compose.yml
    permissions: "0644"
    owner: "ubuntu"
    content: |
      version: "3.3"
      services:
        ssd_mobilenet_v2:
          image: ghcr.io/onspecta/dls_ssd_mobilenet_v2:1.0.0
          ports:
            - "7000:8888"
          privileged: true
        image_segmentation:
          image: ghcr.io/onspecta/dls_image_segmentation:1.0.1
          ports:
            - "8000:8888"
          privileged: true
        yolo3_tf2:
          image: ghcr.io/onspecta/dls_yolov3_tf2:1.0.1
          ports:
            - "9000:8888"
          privileged: true

runcmd:
  - echo 'OCI Ampere Onspecta Tensorflow provided by Terraform.' >> /etc/motd
  - docker-compose -f /opt/onspecta/docker-compose.yml up -d
