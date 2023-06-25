#!/usr/bin/env python3

import json
import boto3

# Создаем клиент для работы с EC2
ec2_client = boto3.client('ec2', region_name='eu-central-1')

# Выполняем запрос на получение информации об экземплярах
response = ec2_client.describe_instances()

# Создаем словарь для группировки данных по тегам
inventory = {}

# Извлекаем нужные данные из ответа и группируем их
for reservation in response['Reservations']:
    for instance in reservation['Instances']:
        name = ""
        ip = ""
        tag = ""

        # Ищем нужные данные в тегах экземпляра
        for tag_entry in instance.get('Tags', []):
            if tag_entry['Key'] == 'Name':
                name = tag_entry['Value']
            elif tag_entry['Key'] == 'env':
                tag = tag_entry['Value']

        # Получаем IP-адрес
        ip = instance.get('PublicIpAddress', 'N/A')

        # Проверяем, что все нужные данные присутствуют
        if name and ip and tag:
            # Добавляем данные в словарь inventory
            if tag.upper() in inventory:
                inventory[tag.upper()].append((name, ip))
            else:
                inventory[tag.upper()] = [(name, ip)]

# Записываем данные в файл инвентари
with open("inventory.ini", "w") as file:
    for tag, instances in inventory.items():
        file.write(f"[{tag}]\n")
        for instance in instances:
            file.write(f"{instance[0]} ansible_host={instance[1]} ansible_user=ubuntu\n")

    # Добавляем общую группу
    file.write("\n[ALL]\n")
    for tag in inventory.keys():
        file.write(f"{tag}\n")
