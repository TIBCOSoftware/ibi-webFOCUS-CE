#!/bin/bash

# Kubernetes Installation and Deployment Script for RHEL 9

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# Variables
POD_NETWORK_CIDR="10.244.0.0/16"  # CIDR for pod network; adjust if necessary
K8S_VERSION="1.28"  # Specify the desired Kubernetes version

# Function to display banners with timestamps
banner() {
  local message="$1"
  echo "=================================================="
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $message"
  echo "=================================================="
}

# Update and install dependencies
banner "Updating system packages"
dnf update -y

banner "Installing required packages"
dnf install -y yum-utils device-mapper-persistent-data lvm2

# Install EPEL repository if not already installed
if ! rpm -qa | grep -qw epel-release; then
  banner "Installing EPEL repository"
  dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
else
  banner "EPEL repository already installed"
fi

# Install additional utilities
banner "Installing additional utilities"
dnf install -y tmux nano

# Add Docker repository if not already added
if ! dnf repolist | grep -qw docker-ce-stable; then
  banner "Adding Docker repository"
  dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  dnf makecache
else
  banner "Docker repository already added"
fi

# Install containerd if not already installed
if ! command -v containerd &> /dev/null; then
  banner "Installing containerd"
  dnf install -y containerd.io
else
  banner "containerd already installed"
fi

# Configure containerd
banner "Configuring containerd"
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable --now containerd.service
sleep 10
sudo systemctl status containerd --no-pager

# Disable swap if not already disabled
if swapon --summary | grep -q 'partition'; then
  banner "Disabling swap"
  swapoff -a
  sed -i '/ swap / s/^/#/' /etc/fstab
else
  banner "Swap already disabled"
fi

# Install kernel headers if not already installed
if ! rpm -qa | grep -qw "kernel-devel-$(uname -r)"; then
  banner "Installing kernel headers"
  dnf install -y kernel-devel-$(uname -r)
else
  banner "Kernel headers already installed"
fi

# Load necessary kernel modules
banner "Loading kernel modules"
modprobe br_netfilter
modprobe ip_vs
modprobe ip_vs_rr
modprobe ip_vs_wrr
modprobe ip_vs_sh
modprobe overlay

# Ensure modules load on boot
banner "Ensuring kernel modules load on boot"
cat > /etc/modules-load.d/kubernetes.conf << EOF
br_netfilter
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
overlay
EOF

# Set system configurations for Kubernetes networking
banner "Setting system configurations"
cat > /etc/sysctl.d/kubernetes.conf << EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Configure firewall rules
banner "Configuring firewall rules"
firewall-cmd --zone=public --permanent --add-port=6443/tcp
firewall-cmd --zone=public --permanent --add-port=2379-2380/tcp
firewall-cmd --zone=public --permanent --add-port=10250/tcp
firewall-cmd --zone=public --permanent --add-port=10251/tcp
firewall-cmd --zone=public --permanent --add-port=10252/tcp
firewall-cmd --zone=public --permanent --add-port=10255/tcp
firewall-cmd --zone=public --permanent --add-port=5473/tcp
firewall-cmd --reload

# Set SELinux in permissive mode if not already set
if [ "$(getenforce)" != "Permissive" ]; then
  banner "Setting SELinux to permissive mode"
  setenforce 0
  sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
else
  banner "SELinux already in permissive mode"
fi

# Add Kubernetes repository
banner "Adding Kubernetes repository"
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

# Install Kubernetes components if not already installed
if ! command -v kubeadm &> /dev/null; then
  banner "Installing Kubernetes components"
  dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
  systemctl enable --now kubelet
  systemctl start kubelet
else
  banner "Kubernetes components already installed"
fi

# Initialize Kubernetes master node if not already initialized
if [ ! -f /etc/kubernetes/admin.conf ]; then
  banner "Initializing Kubernetes master node"
  if ! kubeadm init --pod-network-cidr="$POD_NETWORK_CIDR" | tee /root/kubeadm-init.out; then
    echo "ERROR: kubeadm init failed. Please check the logs for details." >&2
    exit 1
  fi

  banner "Setting up kubeconfig for root"
  mkdir -p $HOME/.kube
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  chown $(id -u):$(id -g) $HOME/.kube/config

  # Deploy Flannel pod network if not already deployed
  if ! kubectl get pods -A | grep -q flannel; then
    banner "Deploying Flannel pod network"
    if ! kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml; then
      echo "ERROR: Failed to deploy Flannel pod network. Please check the logs for details." >&2
      exit 1
    fi
  else
    banner "Flannel pod network already deployed"
  fi

  # Enable scheduling on the master node
  banner "Enabling scheduling on the master node"
  kubectl taint nodes --all node-role.kubernetes.io/master- || banner "Scheduling already enabled on the master node"
else
  banner "Kubernetes master node already initialized"
fi


banner "Kubernetes installation and deployment completed successfully"

# Install Helm
banner "Checking for Helm installation"
if ! command -v helm &> /dev/null; then
  banner "Helm not found. Installing Helm..."
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
  rm -f get_helm.sh
else
  banner "Helm is already installed. Version: $(helm version --short)"
fi

# Install Helmfile
banner "Checking for Helmfile installation"
if ! command -v helmfile &> /dev/null; then
  banner "Helmfile not found. Installing Helmfile..."
  HELMFILE_URL="https://github.com/helmfile/helmfile/releases/download/v0.169.1/helmfile_0.169.1_linux_amd64.tar.gz"
  wget $HELMFILE_URL -O helmfile_0.169.1_linux_amd64.tar.gz
  tar -xvf helmfile_0.169.1_linux_amd64.tar.gz
  mv helmfile /usr/local/bin/
  chmod +x /usr/local/bin/helmfile
  rm -f helmfile_0.169.1_linux_amd64.tar.gz
else
  banner "Helmfile is already installed. Version: $(helmfile --version)"
fi

banner "Helm and Helmfile installation check completed successfully"