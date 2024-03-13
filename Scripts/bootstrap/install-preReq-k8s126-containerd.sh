#!/bin/bash
{
set +x
set -e
set -u
set -o pipefail

printAndRunCommand() {
  limit=$(echo -n "$@" | wc -m)
  limit=$(($limit + 50))
  if [ "$limit" -gt "100" ]; then
    limit=100
  fi
  # shellcheck disable=SC2016
  printf '=%.0s' $(seq 1 $limit)
  echo ""
  echo "     Running command [$@]"
  printf '=%.0s' $(seq 1 $limit)
  echo ""
  "$@"
  printf '=%.0s' $(seq 1 $limit)
  echo ""
}

sudo apt-get -y update
#sudo apt-get -y upgrade
sudo apt-get -y install curl


printAndRunCommand echo "Installing Docker"
#### Docker
# Install Docker CE
## Set up the repository:
### Install packages to allow apt to use a repository over HTTPS
sudo apt-get update && sudo apt-get install -y \
apt-transport-https ca-certificates curl software-properties-common gnupg2 net-tools jq apache2-utils

sudo apt-get update
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER
#newgrp docker

printAndRunCommand echo "End Installing Docker"

#### End Docker
printAndRunCommand echo "Installing kubeadm kubelet kubectl"

  # Install 1.26 K8s

  # Update and install dependencies
apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Kubernetes signing key
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo rm -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.26/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.26/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Add Docker repository for containerd packages
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update apt package index
sudo apt-get update

# Install containerd
sudo apt-get install -y containerd.io

# Configure containerd and set SystemdCgroup
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# Set SystemdCgroup to true
sudo sed -i '/SystemdCgroup = false/c\SystemdCgroup = true' /etc/containerd/config.toml

# Restart containerd to apply the configuration
sudo systemctl restart containerd
sudo systemctl enable containerd

# Install kubelet, kubeadm and kubectl
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo "source <(kubeadm completion bash);source <(kubectl completion bash);alias nano='nano -cmET4';echo 'Hello k8s';source /usr/share/bash-completion/bash_completion" >>~/.bashrc
echo "source <(kubeadm completion bash);source <(kubectl completion bash);alias nano='nano -cmET4';echo 'Hello k8s';source /usr/share/bash-completion/bash_completion" >>/home/"${USER}"/.bashrc

printAndRunCommand echo "End Installing kubeadm kubelet kubectl"

printAndRunCommand echo "Installing helm and helmfile"

# Removed kubeadmin code - moved to helmsync script
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
wget -q https://github.com/roboll/helmfile/releases/download/v0.139.9/helmfile_linux_amd64
chmod +x helmfile_linux_amd64
sudo mv helmfile_linux_amd64 /usr/sbin/helmfile

echo "export KUBE_EDITOR=nano" >>/home/${USER}/.bashrc

printAndRunCommand echo "Done Installing helm and helmfile"

curl -sS https://webinstall.dev/k9s | bash

# Check if all we need is installed now or not ..
# This should produce 4 lines output
if ( type kubectl >/dev/null 2>/dev/null ); then echo "==     ===> kubectl installed"; fi
if ( type helm >/dev/null 2>/dev/null ); then echo "==     ===> helm installed";  fi
if ( type helmfile >/dev/null 2>/dev/null ); then echo "==     ===> helmfile installed"; fi
if ( type kubeadm >/dev/null 2>/dev/null ); then echo "==     ===> kubeadm installed"; fi

cd ~
cat <<'EOF' >>/home/"${USER}"/done-withuserData.text

EOF
} 2>&1 | tee -a /home/"${USER}"/userdata-install.log
