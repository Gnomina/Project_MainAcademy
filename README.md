# Project_MainAcademy
Project at MainAcademy shcool
http://35.242.240.246:8080/




Start

local jenkins server need to install:
java, jenkins, aws-cli, ansible, terraform, boto3, botocore.

jenkins config(Amazon Web Services SDK :: All, CloudBees AWS Credentials Plugin, Terraform, Ansible)

Для правильной работы скрипта нужно отключить в ansible.cfg  проверку ключа, добавив две строки
[defaults]
host_key_checking = false
В этом пайплайне используется самонаписанный Ansible Dynamic Inventory. для того чтоб он работал не нужно делать IAM роль и подписывать ее на инстанс.
Но нужно разрешение у пользователя на обработку AWS CLI: ec2:DescribeInstances
На основе команды aws ec2 describe-instances --region eu-central-1. после чего написал Python script который парсит данные инстанса, оставляя 
только название из тега, тег dev/prod/docker. В теге инстанса обязательно должен быть параметр env, при этом не важно какое у него
будет значение, в инвентори создастся новая группа с которая будет называться так же как значение.

Пример tag(key "dev" : value "Dev") при таком теге в инвентори мы получим "test1 ansible_host=18.195.115.24 ansible_user=ubuntu"


