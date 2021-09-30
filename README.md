![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# terraform-oci-ampere-tensorflow

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Demo Descriptions

This terraform code supports two demos: 
* Object Detection And Classification (Latency Demo)
* Image Segmentation (Throughput Demo)

After completing the instructions of **"Launching A1 Shape With Terraform"** below,
examine the IP address of the compute instance using Oracle Cloud Console. Usually, it will take a few minutes, after the
instance is provisioned, for docker containers to be initialized and started. 

The demos run on Jupyter Notebook throught browser **(Please use Chrome for the best result)**


## Latency Demo URL on port 7000 ##

* Point browser to http://<instance ip>:7000
* Click folder "mldemos"
* Click "ssd_mobilenet_v2"
* Click "detect_video_altra.ipynb". The kernel script is displayed.
* Click Run. 
* The video should be displayed on the brower with the detection results.
  
## Throughput Demo URL on port 8000 ## 
* Point browser to http://<instance ip>:8000
* Click folder "mldemos"
* Click "image_segmentation"
* Click "oxford_pets_image_segmentation_altra.ipynb". The kernel script is displayed.
* Click Run through the last kernel cells. 
* It will take a minute or two to process all the images. The FPS is displayed with selective images and results.

# Lauching A1 Shape With Terraform

## Description

Terraform code to launch a Ampere A1 Shape on Oracle Cloud Infrastructure (OCI) Free-Tier with a Tensorflow DEMO workload running via Docker.

## Requirements

 * [Terraform](https://www.terraform.io/downloads.html)
 * [Oracle OCI "Always Free" Account](https://www.oracle.com/cloud/free/#always-free)



## What exactly is Terraform doing

The goal of this code is to supply the minimal ammount of information to quickly have working Ampere A1 instances on OCI ["Always Free"](https://www.oracle.com/cloud/free/#always-free).
To keep things simple, The root compartment will be used (compartment id and tenancy id are the same) when launching the instance.  

Addtional tasks performed by this code:

* Dynamically creating sshkeys to use when logging into the instance.
* Dynamically getting region, availability zone and image id..
* Creating necessary core networking configurations for the tenancy
* Rendering metadata to pass into the Ampere A1 instance to install and configure Docker and launch a Tensorflow workload
* Launch 1 Ampere A1 instance with 24GB RAM, 4 Cores, and pass in rendered metadata 
* Output IP information to connect to the instance.


To get started clone this repository from GitHub locally.

## Configuration with terraform.tfvars

The easiest way to configure is to use a terraform.tfvars in the project directory.  
Please note that Compartment OCID are the same as Tenancy OCID for Root Compartment.
The following is an example of what terraform.tfvars should look like:

```
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopq"
user_ocid = "ocid1.user.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz0987654321zyxwvustqrponmlkj"
fingerprint = "a1:01:b2:02:c3:03:e4:04:10:11:12:13:14:15:16:17"
```

### Using as a Module

This can also be used as a terraform module.   The following is example code for module usage:

```
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

module "oci-ampere-tensorflow" {
  source                   = "github.com/amperecomputing/terraform-oci-ampere-tensorflow"
  tenancy_ocid             = var.tenancy_ocid
  user_ocid                = var.user_ocid
  fingerprint              = var.fingerprint
  private_key_path         = var.private_key_path
# Optional
# oci_vcn_cidr_block       = "10.2.0.0/16"
# oci_vcn_cidr_subnet      = "10.2.1.0/24"
# instance_prefix          = "ampere-tensorflow-"
# oci_vm_count             = "4"
# ampere_a1_vm_memory      = "8"
# ampere_a1_cpu_core_count = "1"
}

output "oci_ampere_a1_private_ips" {
  value     = module.oci-ampere-a1.AmpereA1_PrivateIPs
}
output "oci_ampere_a1_public_ips" {
  value = module.oci-ampere-a1.AmpereA1_PublicIPs
}
```

### Running Terraform

```
terraform init && terraform plan && terraform apply -auto-approve
```

### Additional Terraform resources for OCI Ampere A1

* Apache Tomcat on Ampere A1: [https://github.com/oracle-devrel/terraform-oci-arch-tomcat-autonomous](https://github.com/oracle-devrel/terraform-oci-arch-tomcat-autonomous)
* WordPress on Ampere A1: [https://github.com/oracle-quickstart/oci-arch-wordpress-mds/tree/master/matomo](https://github.com/oracle-quickstart/oci-arch-wordpress-mds/tree/master/matomo)


## References

* [https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm)
* [Where to Get the Tenancy's OCID and User's OCID](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five)
* [API Key Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth)
* [Instance Principal Authorization](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#instancePrincipalAuth)
* [Security Token Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#securityTokenAuth)
* [How to Generate an API Signing Key](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two)
* [Bootstrapping a VM image in Oracle Cloud Infrastructure using Cloud-Init](https://martincarstenbach.wordpress.com/2018/11/30/bootstrapping-a-vm-image-in-oracle-cloud-infrastructure-using-cloud-init/)
* [Oracle makes building applications on Ampere A1 Compute instances easy](https://blogs.oracle.com/cloud-infrastructure/post/oracle-makes-building-applications-on-ampere-a1-compute-instances-easy?source=:ow:o:p:nav:062520CloudComputeBC)
* [scross01/oci-linux-instance-cloud-init.tf](https://gist.github.com/scross01/5a66207fdc731dd99869a91461e9e2b8)
* [scross01/autonomous_linux_7.7.tf](https://gist.github.com/scross01/bcd21c12b15787f3ae9d51d0d9b2df06)
* [Oracle Cloud Always Free](https://www.oracle.com/cloud/free/#always-free)
