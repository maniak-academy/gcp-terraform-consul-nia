#!/bin/bash

#Utils
sudo apt-get update
sudo apt-get install unzip
sudo apt-get jq
sudo apt-get install curl gnupg lsb-release
sudo curl --fail --silent --show-error --location https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | \
      sudo dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg

sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
 sudo tee -a /etc/apt/sources.list.d/hashicorp.list


sudo apt-get update

sudo apt-get install consul-terraform-sync

sudo apt update -y
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt update -y
sudo apt install vault terraform unzip -y


consul_version = "1.14.3"
#Download Consul
curl --silent --remote-name https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip



#Install Consul
unzip consul_${consul_version}_linux_amd64.zip
sudo chown root:root consul
sudo mv consul /usr/local/bin/
consul -autocomplete-install
complete -C /usr/local/bin/consul consul

#Install consul terraform sync user and groups
sudo useradd --system --home /etc/consul-tf-sync.d --shell /bin/false consul-nia
sudo mkdir -p /opt/consul-tf-sync.d && sudo mkdir -p /etc/consul-tf-sync.d

sudo chown --recursive consul-nia:consul-nia /opt/consul-tf-sync.d && \
sudo chmod -R 0750 /opt/consul-tf-sync.d && \
sudo chown --recursive consul-nia:consul-nia /etc/consul-tf-sync.d && \
sudo chmod -R 0750 /etc/consul-tf-sync.d

#Create Consul User
sudo useradd --system --home /etc/consul.d --shell /bin/false consul
sudo mkdir --parents /opt/consul
sudo chown --recursive consul:consul /opt/consul

#Create Systemd Config
sudo cat << EOF > /etc/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/server.hcl
[Service]
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=always
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

#Create config dir
sudo mkdir --parents /etc/consul.d
sudo touch /etc/consul.d/server.hcl
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/server.hcl


#Create server certificates

sudo chown --recursive consul:consul /etc/consul.d


#Create Consul config file
cat << EOF > /etc/consul.d/server.hcl
node_name = "consul-server"
server = true
datacenter = "maniakacademyDC1"
data_dir = "/opt/consul"
ui_config {
    enabled = true
}
client_addr = "0.0.0.0"
bind_addr = "0.0.0.0"
bootstrap_expect = 1
EOF


# #Create Systemd Config for Consul Terraform Sync
sudo cat << EOF > /etc/systemd/system/consul-tf-sync.service
[Unit]
Description="HashiCorp Consul Terraform Sync - A Network Infra Automation solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target

[Service]
User=root
Group=root
ExecStart=/usr/bin/consul-terraform-sync start -config-file=/etc/consul-tf-sync.d/consul-tf-sync-secure.hcl
KillMode=process
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF



cat << EOF > /etc/consul-tf-sync.d/consul-tf-sync-secure.hcl
# Global Config Options
working_dir = "/opt/consul-tf-sync.d/"
log_level = "info"
buffer_period {
  min = "5s"
  max = "20s"
}

id = "consul-terraform-sync"

consul {
    address = "localhost:8500"
    service_registration {
      enabled = true
      service_name = "consul-terraform-sync"
      default_check {
        enabled = true
        address = "http://localhost:8558"
      }
    }
}


# Terraform Driver Options
driver "terraform" {
  log = true
  path = "/opt/consul-tf-sync.d/"
  required_providers {
    panos = {
      source = "PaloAltoNetworks/panos"
    }
  }
}

# Palo Alto Workflow Options
terraform_provider "panos" {
  alias = "panos1"
  hostname = "${panos_mgmt_addr1}"
  username = "paloalto"
  password = "Pal0Alt0@123"
}

terraform_provider "panos" {
  alias = "panos2"
  hostname = "${panos_mgmt_addr2}"
  username = "paloalto"
  password = "Pal0Alt0@123"
}

##Firewall operations task
task {
  name = "Dynamic_Address_Group_PaloAlto_FW"
  description = "Automate population of dynamic address group"
  module = "github.com/maniak-academy/panos-nia-dag"
  providers = ["panos.panos1"]
  condition "services" {
    names = ["web", "api", "db", "logging"]
  }  
  variable_files = ["/etc/consul-tf-sync.d/panos.tfvars"]
}


task {
  name = "Dynamic_Address_Group_PaloAlto_FW"
  description = "Automate population of dynamic address group"
  module = "github.com/maniak-academy/panos-nia-dag"
  providers = ["panos.panos2"]
  condition "services" {
    names = ["web", "api", "db", "logging"]
  }  
  variable_files = ["/etc/consul-tf-sync.d/panos.tfvars"]
}
EOF

cat << EOF > /etc/consul-tf-sync.d/panos.tfvars
dag_prefix = "cts-addr-grp-"
EOF

#Enable the services
sudo systemctl enable consul
sudo service consul start
sudo service consul status
sudo systemctl enable consul-tf-sync
sudo service consul-tf-sync start
sudo service consul-tf-sync status

