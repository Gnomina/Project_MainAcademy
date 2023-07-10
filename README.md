# Project_MainAcademy
Project at MainAcademy shcool

This pipeline run on jenkins slave "ubuntu". Slave created on pipeline Parametr-start-instance (tag-docker) + ansible-dynamic-inventory
Pipeline build docker container and uploads it to the Elastic Container Registry. 
Elastic Container Registry created on pipeline Create-VPS-SG-ECR-Inst_off.
Get all needed data from s3bucket terraform backend.


Start

local jenkins server need to install:
java, jenkins, aws-cli, ansible, terraform

jenkins config(Amazon Web Services SDK :: All, CloudBees AWS Credentials Plugin, Terraform, Ansible)


