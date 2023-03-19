# Задание  
* Создать через Terraform 3 vps в DigitalOcean/AWS/Google Cloud (где нравится)  
* Через Ansible установить на них docker  
* Создать на нодах kubernetes кластер с помощью rke, с ингрессом  
* Подготовить docker контейнер на основе nginx, со статическим сайтом из одной HTML'ки  
* Сделать Helm-чарт, в котором будет deployment с контейнером из предыдущего шага, service для этого deployment'а и ingress для доступа снаружи  

# Решение  
## Terraform и AWS  

Через Terraform в AWS создаются ресурсы, необходимые для размещения трех ВМ в трех разных зонах доступности (VPC, subnets, security group), а также сами ВМ - будущие ноды Kubernetes кластера  

В качестве используемой ОС выбран Amazon Linux 2 - просто потому что он хороший и входит во Free Tier  

Тип инстанса "t2.medium" был выбран по причине того, что "t2.micro", входящий во Free Tier, испытывал проблемы с утилизацией CPU во время настройки kubernetes-кластера через rke  

Время создания всех ресурсов ~ 1 мин  

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

## Ansible  

Установка docker на узлы будущего kubernetes-кластера реализована с помощью одного плейбука: [install_docker_knodes.yml](./Ansible/install_docker_knodes.yml)  

## Установка Kubernetes  
Список команд, выполненных на будущей мастер-ноде перед конфигурацией кластера через rke:  
```
sudo adduser rancher
sudo usermod -aG docker rancher
sudo bash
echo "rancher ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
exit
sudo su - rancher
mkdir .ssh
chmod 700 .ssh
touch .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
ssh-keygen
cat .ssh/id_rsa.pub >> .ssh/authorized_keys
```

Для выполнения этих же команд на остальных нодах, создан ещё один Ansible-плейбук: [apply_prerequisites_for_rke.yml](./Ansible/apply_prerequisites_for_rke.yml)  

Установка rke:  
```
wget https://github.com/rancher/rke/releases/download/v1.3.19/rke_linux-amd64
mv rke_linux-amd64 rke
sudo mv rke /usr/local/bin/
sudo chown rancher:rancher /usr/local/bin/rke
sudo chmod 750 /usr/local/bin/rke
```
