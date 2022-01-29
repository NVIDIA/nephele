# NEPHELE

## Prerequisites

### Install enroot
```bash
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v3.4.0/enroot_3.4.0-1_amd64.deb
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v3.4.0/enroot+caps_3.4.0-1_amd64.deb
apt install -y ./*.deb
```

### Install terraform
```bash
curl -fSsL https://releases.hashicorp.com/terraform/1.1.4/terraform_1.1.4_windows_amd64.zip | zcat > /usr/local/bin/terraform
chmod +x /usr/local/bin/terraform
```

### Install ansible
```bash
apt install python3-pip
pip3 install --upgrade ansible netaddr
```

### Install provider CLI
#### Azure
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli


## Setup

### Edit cluster configuration
```bash
vi nephele.conf
```

### One time setup
```bash
./nephele init
```

### Create the cluster
```bash
./nephele create
```

### Connect to the cluster
```bash
./nephele connect
```

### Destroy the cluster
```bash
./nephele destroy
```
