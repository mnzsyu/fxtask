# Задание
* Создать через Terraform 3 vps в DigitalOcean/AWS/Google Cloud (где нравится)  
* Через Ansible установить на них docker  
* Создать на нодах kubernetes кластер с помощью rke, с ингрессом  
* Подготовить docker контейнер на основе nginx, со статическим сайтом из одной HTML'ки  
* Сделать Helm-чарт, в котором будет deployment с контейнером из предыдущего шага, service для этого deployment'а и ingress для доступа снаружи  

# Решение
## Terraform и AWS

| Файл Terraform                                         | Содержимое                                      |
| :-----------------------------------------------------:|:------------------------------------------------|
| [provider.tf](./Terraform/provider.tf)                 | Провайдер AWS                                   |
| [config.tf](./Terraform/config.tf)                     | Настройки для сохранения Terraform state в S3   |
| [data.tf](./Terraform/data.tf)                         | Используемые данные                             |
| [variables.tf](./Terraform/variables.tf)               | Используемые переменные                         |
| [terraform.tfvars](./Terraform/terraform.tfvars)       | Задаваемые значения переменных                  |
| [main.tf](./Terraform/main.tf)                         | Описание VPC, сетей и security групп            |
| [instances.tf](./Terraform/instances.tf)               | Описание ВМ EC2                                 |
| [outputs.tf](./Terraform/outputs.tf)                   | Получение IP-адресов ВМ после terraform apply   |
