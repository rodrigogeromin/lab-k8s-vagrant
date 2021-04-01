## Pré-requisitos

--------

Esse laboratório requer:

Softwares:
* **Vagrant**: 2.2.7
* **Linux:** VirtualBox
* **Windows:** VirtualBox
* **openssh client**
* **Git Client**

Hardware
* **CPU:** 6
* **Memória:** 8GB
* **HD:** 120GB

>**Obs.:** O Disco é flexivel sendo possível diminuir alterando o Vagrantfile

## Preparando a infraestrutura

---------

1. Acesse o link abaixo:

* https://www.vagrantup.com/downloads.html

* https://releases.hashicorp.com/vagrant/2.2.7/

2. Faça o download do Vagrant para seu sistema operacional
3. Realize a instalação
* Debian-Based:
  * dpkg -i <file.deb>
* RedHat-Based:
  * rpm -ivh <file.rpm>
* Windows:
  *  Clique no instalador
  *  Siga o assistente até o finalizar a instalação
  *  Reinicie o computador


## Download do Ubuntu 20.04
------------

Para realizar o download da "box" do Centos 7, execute o comando:

#### Linux
```bash
$ vagrant box add ubuntu/focal64 --box-version 20210330.0.0
$ vagrant plugin install scp-vagrant
```

#### Windows
```powershell
PS> vagrant.exe box add ubuntu/focal64 --box-version 20210330.0.0
PS> vagrant.exe plugin install scp-vagrant
```
>**Obs.:** *Selecione o virtualizador virtualbox.*

>**Atenção:** Esse laboratório só funciona com o Virtualbox.

## Criando chaves SSH

Execute os comando abaixo:

#### Linux

```
$ ssh-keygen -f files/id_rsa
```

#### Windows
```powershell
PS> ssh-keygen.exe -f files/id_rsa
```

#### Linux
```bash
$ vagrant up
```

#### Windows
```powershell
PS> vagrant.exe up
```


## O Projeto

Esse projeto quatro maquinas virtuais: 

* controller **[172.25.10.10]**
* kubemaster01 **[172.25.10.20]**
* node01 **[172.25.10.30]**
* node02 **[172.5.10.40]**

>O endereço do loadbalance é: **[172.25.10.50]**

#### Controller

Essa máquina virtual é responsável por instalar e gerenciar o cluster kubernetes. Ela possui os seguintes utilitários:

* Ansible
* Docker
* Helm Client
* Kubectl
* Docker Registry

Ela também é utilizada como um gerenciador de instalação. As configurações executadas por ela são:

* Instalação do cluster Kubernetes através do kubespray. **(Ansible)**
* Instalação de um loadbalance para o k8s. **(Ansible)**
* Instalação do ingress controller. **(Helm)**
* Instalação de um serviço de docker registry. **(Ansible)**
* Armazenar imagens dos projetos. **(Docker Registry)**


#### Kubemaster01

Essa maquina virtual faz o papel de master do cluster kubernetes. Ela faz a orquestração do cluster e armazena o banco de dados etcd.

#### Node01 e Node02

Essas são as máquinas virtuais onde são executados nossos workloads. Fazem o papel de nó do cluster.

## Após a instalação

#### Comandos úteis:

Acessando o controlador:
```
vagrant ssh controller
```

Varificando o cluster k8s:
```
kubectl get nodes
```

O projeto sobe um serviço do nginx com o objetivo de testar se a instalação do cluster foi bem sucedida. Para verificar, acesse o endereço:

http://nginx.172.25.10.50.nip.io/

Veja as configurações desse workload:

```
kubectl get all
kubectl get ingress
```
Abaixo o resultado esperado:
```
[vagrant@controller ~]$ kubectl get all
NAME                         READY   STATUS    RESTARTS   AGE
pod/nginx-6799fc88d8-b7r96   1/1     Running   0          5m57s

NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.233.0.1     <none>        443/TCP   13m
service/nginx        ClusterIP   10.233.38.25   <none>        80/TCP    5m56s

NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   1/1     1            1           5m57s

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-6799fc88d8   1         1         1       5m57s
[vagrant@controller ~]$ kubectl get ingress
Warning: extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
NAME            CLASS    HOSTS                       ADDRESS        PORTS   AGE
ingress-nginx   <none>   nginx.172.25.10.50.nip.io   172.25.10.50   80      6m7s
```
Se você chegou até aqui é um bom sinal. Estamos prontos para utilizar nosso laboratório. :)
