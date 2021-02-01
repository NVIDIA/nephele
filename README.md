# NEPHELE

## Prerequisites

### Install enroot
```bash
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v3.2.0/enroot_3.2.0-1_amd64.deb
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v3.2.0/enroot+caps_3.2.0-1_amd64.deb
apt install -y ./*.deb
```

### Install terraform
```bash
curl -fSsL https://releases.hashicorp.com/terraform/0.14.5/terraform_0.14.5_linux_amd64.zip | zcat > /usr/local/bin/terraform
chmod +x /usr/local/bin/terraform
```

### Install ansible
```bash
apt install python3-pip
pip3 install --upgrade ansible
```

## Setup

### Edit cluster configuration
```bash
vi nephele.conf
```

### One time setup
```bash
./nephele.sh init
```

### Create the cluster
```bash
./nephele.sh create
```

### Connect to the cluster
```bash
./nephele.sh connect
```

### Destroy the cluster
```bash
./nephele.sh destroy
```
