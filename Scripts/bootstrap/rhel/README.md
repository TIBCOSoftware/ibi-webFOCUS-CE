
# Kubernetes Installation and Deployment Script for RHEL 9

## Overview
This script automates the installation and configuration of a Kubernetes cluster on a Red Hat Enterprise Linux (RHEL) 9 system. It ensures all required components, configurations, and tools are installed idempotently, meaning that if a step has already been completed, it will not be repeated.

### Key Features:
1. Updates system packages and installs dependencies.
2. Configures and installs:
   - Container runtime (`containerd`).
   - Kubernetes components (`kubelet`, `kubeadm`, `kubectl`).
   - Networking (Flannel pod network).
   - Essential utilities (`tmux`, `nano`, etc.).
3. Ensures system settings are configured:
   - Disables swap.
   - Loads kernel modules.
   - Configures SELinux and firewall rules.
4. Installs additional tools:
   - Helm: A Kubernetes package manager.
   - Helmfile: A declarative configuration tool for managing Helm charts.
5. Idempotency: Checks if components are already installed and skips redundant steps.
6. Error Handling: Exits the script on critical failures (e.g., `kubeadm init` failure).

## Usage

### Prerequisites
- Ensure you run this script as a user with root privileges (`sudo`).
- Internet connectivity is required to download dependencies.

### Running the Script
1. Save the script as `install_k8s_rhel9.sh`.
2. Make it executable:
   ```bash
   chmod +x install_k8s_rhel9.sh
   ```
3. Run the script:
   ```bash
   sudo ./install_k8s_rhel9.sh
   ```
   You can also run the script directly from the web using `curl`:
   ```bash
   curl https://raw.githubusercontent.com/TIBCOSoftware/ibi-webFOCUS-CE/refs/heads/work-in-progress/Scripts/bootstrap/rhel/install-preReq-k8s126-containerd.sh | sudo sh -
    ```

### What the Script Does
The script performs the following steps:
- Updates and installs necessary system packages.
- Adds Docker and Kubernetes repositories.
- Installs and configures the container runtime (`containerd`).
- Configures Kubernetes networking and initializes the cluster using `kubeadm`.
- Installs Helm and Helmfile for Kubernetes package management.
- Deploys the Flannel pod network.
- Ensures master node scheduling is enabled.

### Sample output 


## Notes
- **Customizations:** Update `POD_NETWORK_CIDR` and `K8S_VERSION` variables in the script to match your specific requirements.
- **Logs:** Outputs details for each step, making it easier to debug if an error occurs.
- **Error Handling:** If critical components fail (e.g., `kubeadm init`), the script exits with an error message.

## Placeholder for Future Enhancements
- Support for additional Kubernetes pod networks (e.g., Calico).
- Option to configure worker nodes and join them to the cluster.
- Automated generation of Helmfile configurations.
