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
        tags = {}

        # Ищем нужные данные в тегах экземпляра
        for tag_entry in instance.get('Tags', []):
            key = tag_entry['Key']
            value = tag_entry['Value']
            tags[key] = value

        # Получаем IP-адрес
        ip = instance.get('PublicIpAddress', 'N/A')

        # Проверяем, что IP-адрес присутствует и не равен 'N/A'
        if ip != 'N/A' and tags:
            # Добавляем данные в словарь inventory
            for tag_key, tag_value in tags.items():
                if tag_key.lower() not in inventory:
                    inventory[tag_key.lower()] = []
                inventory[tag_key.lower()].append((tag_value, ip))

# Записываем данные в файл инвентари
with open("inventory.ini", "w") as file:
    # Записываем каждый тег в отдельную группу
    for tag, instances in inventory.items():
        file.write(f"[{tag}]\n")
        for instance in instances:
            file.write(f"{instance[0]} ansible_host={instance[1]} ansible_user=ubuntu\n")

    # Создаем общую группу [all]
    file.write("\n[all]\n")
    for tag, instances in inventory.items():
        for instance in instances:
            file.write(f"{instance[0]} ansible_host={instance[1]} ansible_user=ubuntu\n")
