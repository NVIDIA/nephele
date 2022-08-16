# NEPHELE

## Prerequisites

### Install enroot
```bash
sudo apt update -y
arch=$(dpkg --print-architecture)
echo $arch

curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v3.4.0/enroot_3.4.0-1_${arch}.deb
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v3.4.0/enroot+caps_3.4.0-1_${arch}.deb
sudo apt install -y ./*.deb
rm enroot*
```

### Install terraform and ansible
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
sudo apt install -y build-essential terraform ansible
```

### Check installation
```bash
terraform --version
ansible --version
```

### If using Azure, additionally install the Azure CLI
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login
```


## Setup

### Cloning the repo
Remember to include the recursive flag for submodules.
```bash
git clone --recursive https://github.com/NVIDIA/nephele.git
```

### Edit cluster configuration
```bash
vi nephele.conf
```

### One time setup
```bash
export CONTAINERIZED_BUILD=1
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
