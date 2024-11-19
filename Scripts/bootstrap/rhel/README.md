
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

```bash
[ ~]$ curl https://raw.githubusercontent.com/TIBCOSoftware/ibi-webFOCUS-CE/refs/heads/work-in-progress/Scripts/bootstrap/rhel/install-preReq-k8s126-containerd.sh | sudo sh -
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  6877  100  6877    0     0  36386      0 --:--:-- --:--:-- --:--:-- 36579
[sudo] password for pshah:
==================================================
2024-11-19 00:15:55 - Updating system packages
==================================================
Last metadata expiration check: 5:28:11 ago on Mon 18 Nov 2024 06:48:09 PM UTC.
Dependencies resolved.
Nothing to do.
Complete!
==================================================
2024-11-19 00:16:21 - Installing required packages
==================================================
Last metadata expiration check: 5:28:13 ago on Mon 18 Nov 2024 06:48:09 PM UTC.
Dependencies resolved.
========================================================================================================================================================================================================================================================================================
 Package                                                                   Architecture                                       Version                                                         Repository                                                                           Size
========================================================================================================================================================================================================================================================================================
Installing:
 device-mapper-persistent-data                                             x86_64                                             1.0.9-3.el9_4                                                   rhui-rhel-9-for-x86_64-baseos-rhui-rpms                                             1.0 M
 lvm2                                                                      x86_64                                             9:2.03.24-2.el9                                                 rhui-rhel-9-for-x86_64-baseos-rhui-rpms                                             1.5 M
 yum-utils                                                                 noarch                                             4.3.0-16.el9                                                    rhui-rhel-9-for-x86_64-baseos-rhui-rpms                                              44 k
Installing dependencies:
 device-mapper-event                                                       x86_64                                             9:1.02.198-2.el9                                                rhui-rhel-9-for-x86_64-baseos-rhui-rpms                                              36 k
 device-mapper-event-libs                                                  x86_64                                             9:1.02.198-2.el9                                                rhui-rhel-9-for-x86_64-baseos-rhui-rpms                                              33 k
 libaio                                                                    x86_64                                             0.3.111-13.el9                                                  rhui-rhel-9-for-x86_64-baseos-rhui-rpms                                              26 k
 lvm2-libs                                                                 x86_64                                             9:2.03.24-2.el9                                                 rhui-rhel-9-for-x86_64-baseos-rhui-rpms                                             1.0 M

Transaction Summary
========================================================================================================================================================================================================================================================================================
Install  7 Packages

Total download size: 3.7 M
Installed size: 9.5 M
Downloading Packages:
(1/7): libaio-0.3.111-13.el9.x86_64.rpm                                                                                                                                                                                                                 166 kB/s |  26 kB     00:00
(2/7): device-mapper-event-1.02.198-2.el9.x86_64.rpm                                                                                                                                                                                                    221 kB/s |  36 kB     00:00
(3/7): device-mapper-event-libs-1.02.198-2.el9.x86_64.rpm                                                                                                                                                                                               654 kB/s |  33 kB     00:00
(4/7): device-mapper-persistent-data-1.0.9-3.el9_4.x86_64.rpm                                                                                                                                                                                           4.4 MB/s | 1.0 MB     00:00
(5/7): yum-utils-4.3.0-16.el9.noarch.rpm                                                                                                                                                                                                                1.2 MB/s |  44 kB     00:00
(6/7): lvm2-2.03.24-2.el9.x86_64.rpm                                                                                                                                                                                                                    9.4 MB/s | 1.5 MB     00:00
(7/7): lvm2-libs-2.03.24-2.el9.x86_64.rpm                                                                                                                                                                                                               6.8 MB/s | 1.0 MB     00:00
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                                                                   6.5 MB/s | 3.7 MB     00:00
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                                                                1/1
  Installing       : device-mapper-event-libs-9:1.02.198-2.el9.x86_64                                                                                                                                                                                                               1/7
  Installing       : libaio-0.3.111-13.el9.x86_64                                                                                                                                                                                                                                   2/7
  Installing       : device-mapper-event-9:1.02.198-2.el9.x86_64                                                                                                                                                                                                                    3/7
  Running scriptlet: device-mapper-event-9:1.02.198-2.el9.x86_64                                                                                                                                                                                                                    3/7
Created symlink /etc/systemd/system/sockets.target.wants/dm-event.socket � /usr/lib/systemd/system/dm-event.socket.

  Installing       : lvm2-libs-9:2.03.24-2.el9.x86_64                                                                                                                                                                                                                               4/7
  Installing       : device-mapper-persistent-data-1.0.9-3.el9_4.x86_64                                                                                                                                                                                                             5/7
  Installing       : lvm2-9:2.03.24-2.el9.x86_64                                                                                                                                                                                                                                    6/7
  Running scriptlet: lvm2-9:2.03.24-2.el9.x86_64                                                                                                                                                                                                                                    6/7
Created symlink /etc/systemd/system/sysinit.target.wants/lvm2-monitor.service � /usr/lib/systemd/system/lvm2-monitor.service.
Created symlink /etc/systemd/system/sysinit.target.wants/lvm2-lvmpolld.socket � /usr/lib/systemd/system/lvm2-lvmpolld.socket.

  Installing       : yum-utils-4.3.0-16.el9.noarch                                                                                                                                                                                                                                  7/7
  Running scriptlet: yum-utils-4.3.0-16.el9.noarch                                                                                                                                                                                                                                  7/7
  Verifying        : libaio-0.3.111-13.el9.x86_64                                                                                                                                                                                                                                   1/7
  Verifying        : device-mapper-persistent-data-1.0.9-3.el9_4.x86_64                                                                                                                                                                                                             2/7
  Verifying        : device-mapper-event-9:1.02.198-2.el9.x86_64                                                                                                                                                                                                                    3/7
  Verifying        : device-mapper-event-libs-9:1.02.198-2.el9.x86_64                                                                                                                                                                                                               4/7
  Verifying        : lvm2-9:2.03.24-2.el9.x86_64                                                                                                                                                                                                                                    5/7
  Verifying        : lvm2-libs-9:2.03.24-2.el9.x86_64                                                                                                                                                                                                                               6/7
  Verifying        : yum-utils-4.3.0-16.el9.noarch                                                                                                                                                                                                                                  7/7

Installed:
  device-mapper-event-9:1.02.198-2.el9.x86_64   device-mapper-event-libs-9:1.02.198-2.el9.x86_64   device-mapper-persistent-data-1.0.9-3.el9_4.x86_64   libaio-0.3.111-13.el9.x86_64   lvm2-9:2.03.24-2.el9.x86_64   lvm2-libs-9:2.03.24-2.el9.x86_64   yum-utils-4.3.0-16.el9.noarch

Complete!
==================================================
2024-11-19 00:16:34 - Installing EPEL repository
==================================================
Last metadata expiration check: 5:28:26 ago on Mon 18 Nov 2024 06:48:09 PM UTC.
epel-release-latest-9.noarch.rpm                                                                                                                                                                                                                         55 kB/s |  18 kB     00:00
Dependencies resolved.
========================================================================================================================================================================================================================================================================================
 Package                                                                Architecture                                                     Version                                                           Repository                                                              Size
========================================================================================================================================================================================================================================================================================
Installing:
 epel-release                                                           noarch                                                           9-8.el9                                                           @commandline                                                            18 k

Transaction Summary
========================================================================================================================================================================================================================================================================================
Install  1 Package

Total size: 18 k
Installed size: 26 k
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                                                                1/1
  Installing       : epel-release-9-8.el9.noarch                                                                                                                                                                                                                                    1/1
  Running scriptlet: epel-release-9-8.el9.noarch                                                                                                                                                                                                                                    1/1
Many EPEL packages require the CodeReady Builder (CRB) repository.
It is recommended that you run /usr/bin/crb enable to enable the CRB repository.

  Verifying        : epel-release-9-8.el9.noarch                                                                                                                                                                                                                                    1/1

Installed:
  epel-release-9-8.el9.noarch

Complete!
==================================================
2024-11-19 00:16:37 - Installing additional utilities
==================================================
Extra Packages for Enterprise Linux 9 - x86_64                                                                                                                                                                                                          8.4 MB/s |  23 MB     00:02
Extra Packages for Enterprise Linux 9 openh264 (From Cisco) - x86_64                                                                                                                                                                                    2.6 kB/s | 2.5 kB     00:00
Last metadata expiration check: 0:00:01 ago on Tue 19 Nov 2024 12:16:49 AM UTC.
Dependencies resolved.
========================================================================================================================================================================================================================================================================================
 Package                                                  Architecture                                               Version                                                          Repository                                                                                   Size
========================================================================================================================================================================================================================================================================================
Installing:
 nano                                                     x86_64                                                     5.6.1-6.el9                                                      rhui-rhel-9-for-x86_64-baseos-rhui-rpms                                                     715 k
 tmux                                                     x86_64                                                     3.2a-5.el9                                                       rhui-rhel-9-for-x86_64-baseos-rhui-rpms                                                     476 k

Transaction Summary
========================================================================================================================================================================================================================================================================================
Install  2 Packages

Total download size: 1.2 M
Installed size: 3.8 M
Downloading Packages:
(1/2): tmux-3.2a-5.el9.x86_64.rpm                                                                                                                                                                                                                       1.7 MB/s | 476 kB     00:00
(2/2): nano-5.6.1-6.el9.x86_64.rpm                                                                                                                                                                                                                      2.3 MB/s | 715 kB     00:00
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                                                                   2.8 MB/s | 1.2 MB     00:00
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                                                                1/1
  Installing       : nano-5.6.1-6.el9.x86_64                                                                                                                                                                                                                                        1/2
  Installing       : tmux-3.2a-5.el9.x86_64                                                                                                                                                                                                                                         2/2
  Running scriptlet: tmux-3.2a-5.el9.x86_64                                                                                                                                                                                                                                         2/2
  Verifying        : tmux-3.2a-5.el9.x86_64                                                                                                                                                                                                                                         1/2
  Verifying        : nano-5.6.1-6.el9.x86_64                                                                                                                                                                                                                                        2/2

Installed:
  nano-5.6.1-6.el9.x86_64                                                                                                                     tmux-3.2a-5.el9.x86_64

Complete!
==================================================
2024-11-19 00:17:11 - Adding Docker repository
==================================================
Adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
Docker CE Stable - x86_64                                                                                                                                                                                                                               475 kB/s |  59 kB     00:00
Extra Packages for Enterprise Linux 9 - x86_64                                                                                                                                                                                                           77 kB/s |  37 kB     00:00
Extra Packages for Enterprise Linux 9 openh264 (From Cisco) - x86_64                                                                                                                                                                                    3.8 kB/s | 993  B     00:00
Google Compute Engine                                                                                                                                                                                                                                    27 kB/s | 1.4 kB     00:00
Google Cloud SDK                                                                                                                                                                                                                                        4.5 kB/s | 1.4 kB     00:00
Red Hat Enterprise Linux 9 for x86_64 - AppStream from RHUI (Debug RPMs)                                                                                                                                                                                 15 kB/s | 3.8 kB     00:00
Red Hat Enterprise Linux 9 for x86_64 - AppStream from RHUI (RPMs)                                                                                                                                                                                       20 kB/s | 4.5 kB     00:00
Red Hat Enterprise Linux 9 for x86_64 - AppStream from RHUI (Source RPMs)                                                                                                                                                                                15 kB/s | 3.8 kB     00:00
Red Hat Enterprise Linux 9 for x86_64 - BaseOS from RHUI (Debug RPMs)                                                                                                                                                                                    17 kB/s | 3.8 kB     00:00
Red Hat Enterprise Linux 9 for x86_64 - BaseOS from RHUI (RPMs)                                                                                                                                                                                          16 kB/s | 4.1 kB     00:00
Red Hat Enterprise Linux 9 for x86_64 - BaseOS from RHUI (Source RPMs)                                                                                                                                                                                   17 kB/s | 3.8 kB     00:00
Metadata cache created.
==================================================
2024-11-19 00:17:17 - Installing containerd
==================================================
Last metadata expiration check: 0:00:04 ago on Tue 19 Nov 2024 12:17:16 AM UTC.
Dependencies resolved.
========================================================================================================================================================================================================================================================================================
 Package                                                          Architecture                                          Version                                                         Repository                                                                                 Size
========================================================================================================================================================================================================================================================================================
Installing:
 containerd.io                                                    x86_64                                                1.7.23-3.1.el9                                                  docker-ce-stable                                                                           43 M
Installing dependencies:
 container-selinux                                                noarch                                                3:2.232.1-1.el9                                                 rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                                 60 k

Transaction Summary
========================================================================================================================================================================================================================================================================================
Install  2 Packages

Total download size: 43 M
Installed size: 150 M
Downloading Packages:
(1/2): container-selinux-2.232.1-1.el9.noarch.rpm                                                                                                                                                                                                       419 kB/s |  60 kB     00:00
(2/2): containerd.io-1.7.23-3.1.el9.x86_64.rpm                                                                                                                                                                                                           35 MB/s |  43 MB     00:01
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                                                                    31 MB/s |  43 MB     00:01
Docker CE Stable - x86_64                                                                                                                                                                                                                                38 kB/s | 1.6 kB     00:00
Importing GPG key 0x621E9F35:
 Userid     : "Docker Release (CE rpm) <docker@docker.com>"
 Fingerprint: 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35
 From       : https://download.docker.com/linux/centos/gpg
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                                                                1/1
  Running scriptlet: container-selinux-3:2.232.1-1.el9.noarch                                                                                                                                                                                                                       1/2
  Installing       : container-selinux-3:2.232.1-1.el9.noarch                                                                                                                                                                                                                       1/2
  Running scriptlet: container-selinux-3:2.232.1-1.el9.noarch                                                                                                                                                                                                                       1/2
  Installing       : containerd.io-1.7.23-3.1.el9.x86_64                                                                                                                                                                                                                            2/2
  Running scriptlet: containerd.io-1.7.23-3.1.el9.x86_64                                                                                                                                                                                                                            2/2
  Running scriptlet: container-selinux-3:2.232.1-1.el9.noarch                                                                                                                                                                                                                       2/2
  Running scriptlet: containerd.io-1.7.23-3.1.el9.x86_64                                                                                                                                                                                                                            2/2
  Verifying        : containerd.io-1.7.23-3.1.el9.x86_64                                                                                                                                                                                                                            1/2
  Verifying        : container-selinux-3:2.232.1-1.el9.noarch                                                                                                                                                                                                                       2/2

Installed:
  container-selinux-3:2.232.1-1.el9.noarch                                                                                                      containerd.io-1.7.23-3.1.el9.x86_64

Complete!
==================================================
2024-11-19 00:17:47 - Configuring containerd
==================================================
disabled_plugins = []
imports = []
oom_score = 0
plugin_dir = ""
required_plugins = []
root = "/var/lib/containerd"
state = "/run/containerd"
temp = ""
version = 2

[cgroup]
  path = ""

[debug]
  address = ""
  format = ""
  gid = 0
  level = ""
  uid = 0

[grpc]
  address = "/run/containerd/containerd.sock"
  gid = 0
  max_recv_message_size = 16777216
  max_send_message_size = 16777216
  tcp_address = ""
  tcp_tls_ca = ""
  tcp_tls_cert = ""
  tcp_tls_key = ""
  uid = 0

[metrics]
  address = ""
  grpc_histogram = false

[plugins]

  [plugins."io.containerd.gc.v1.scheduler"]
    deletion_threshold = 0
    mutation_threshold = 100
    pause_threshold = 0.02
    schedule_delay = "0s"
    startup_delay = "100ms"

  [plugins."io.containerd.grpc.v1.cri"]
    cdi_spec_dirs = ["/etc/cdi", "/var/run/cdi"]
    device_ownership_from_security_context = false
    disable_apparmor = false
    disable_cgroup = false
    disable_hugetlb_controller = true
    disable_proc_mount = false
    disable_tcp_service = true
    drain_exec_sync_io_timeout = "0s"
    enable_cdi = false
    enable_selinux = false
    enable_tls_streaming = false
    enable_unprivileged_icmp = false
    enable_unprivileged_ports = false
    ignore_deprecation_warnings = []
    ignore_image_defined_volumes = false
    image_pull_progress_timeout = "5m0s"
    image_pull_with_sync_fs = false
    max_concurrent_downloads = 3
    max_container_log_line_size = 16384
    netns_mounts_under_state_dir = false
    restrict_oom_score_adj = false
    sandbox_image = "registry.k8s.io/pause:3.8"
    selinux_category_range = 1024
    stats_collect_period = 10
    stream_idle_timeout = "4h0m0s"
    stream_server_address = "127.0.0.1"
    stream_server_port = "0"
    systemd_cgroup = false
    tolerate_missing_hugetlb_controller = true
    unset_seccomp_profile = ""

    [plugins."io.containerd.grpc.v1.cri".cni]
      bin_dir = "/opt/cni/bin"
      conf_dir = "/etc/cni/net.d"
      conf_template = ""
      ip_pref = ""
      max_conf_num = 1
      setup_serially = false

    [plugins."io.containerd.grpc.v1.cri".containerd]
      default_runtime_name = "runc"
      disable_snapshot_annotations = true
      discard_unpacked_layers = false
      ignore_blockio_not_enabled_errors = false
      ignore_rdt_not_enabled_errors = false
      no_pivot = false
      snapshotter = "overlayfs"

      [plugins."io.containerd.grpc.v1.cri".containerd.default_runtime]
        base_runtime_spec = ""
        cni_conf_dir = ""
        cni_max_conf_num = 0
        container_annotations = []
        pod_annotations = []
        privileged_without_host_devices = false
        privileged_without_host_devices_all_devices_allowed = false
        runtime_engine = ""
        runtime_path = ""
        runtime_root = ""
        runtime_type = ""
        sandbox_mode = ""
        snapshotter = ""

        [plugins."io.containerd.grpc.v1.cri".containerd.default_runtime.options]

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]

        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          base_runtime_spec = ""
          cni_conf_dir = ""
          cni_max_conf_num = 0
          container_annotations = []
          pod_annotations = []
          privileged_without_host_devices = false
          privileged_without_host_devices_all_devices_allowed = false
          runtime_engine = ""
          runtime_path = ""
          runtime_root = ""
          runtime_type = "io.containerd.runc.v2"
          sandbox_mode = "podsandbox"
          snapshotter = ""

          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            BinaryName = ""
            CriuImagePath = ""
            CriuPath = ""
            CriuWorkPath = ""
            IoGid = 0
            IoUid = 0
            NoNewKeyring = false
            NoPivotRoot = false
            Root = ""
            ShimCgroup = ""
            SystemdCgroup = false

      [plugins."io.containerd.grpc.v1.cri".containerd.untrusted_workload_runtime]
        base_runtime_spec = ""
        cni_conf_dir = ""
        cni_max_conf_num = 0
        container_annotations = []
        pod_annotations = []
        privileged_without_host_devices = false
        privileged_without_host_devices_all_devices_allowed = false
        runtime_engine = ""
        runtime_path = ""
        runtime_root = ""
        runtime_type = ""
        sandbox_mode = ""
        snapshotter = ""

        [plugins."io.containerd.grpc.v1.cri".containerd.untrusted_workload_runtime.options]

    [plugins."io.containerd.grpc.v1.cri".image_decryption]
      key_model = "node"

    [plugins."io.containerd.grpc.v1.cri".registry]
      config_path = ""

      [plugins."io.containerd.grpc.v1.cri".registry.auths]

      [plugins."io.containerd.grpc.v1.cri".registry.configs]

      [plugins."io.containerd.grpc.v1.cri".registry.headers]

      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]

    [plugins."io.containerd.grpc.v1.cri".x509_key_pair_streaming]
      tls_cert_file = ""
      tls_key_file = ""

  [plugins."io.containerd.internal.v1.opt"]
    path = "/opt/containerd"

  [plugins."io.containerd.internal.v1.restart"]
    interval = "10s"

  [plugins."io.containerd.internal.v1.tracing"]

  [plugins."io.containerd.metadata.v1.bolt"]
    content_sharing_policy = "shared"

  [plugins."io.containerd.monitor.v1.cgroups"]
    no_prometheus = false

  [plugins."io.containerd.nri.v1.nri"]
    disable = true
    disable_connections = false
    plugin_config_path = "/etc/nri/conf.d"
    plugin_path = "/opt/nri/plugins"
    plugin_registration_timeout = "5s"
    plugin_request_timeout = "2s"
    socket_path = "/var/run/nri/nri.sock"

  [plugins."io.containerd.runtime.v1.linux"]
    no_shim = false
    runtime = "runc"
    runtime_root = ""
    shim = "containerd-shim"
    shim_debug = false

  [plugins."io.containerd.runtime.v2.task"]
    platforms = ["linux/amd64"]
    sched_core = false

  [plugins."io.containerd.service.v1.diff-service"]
    default = ["walking"]

  [plugins."io.containerd.service.v1.tasks-service"]
    blockio_config_file = ""
    rdt_config_file = ""

  [plugins."io.containerd.snapshotter.v1.aufs"]
    root_path = ""

  [plugins."io.containerd.snapshotter.v1.blockfile"]
    fs_type = ""
    mount_options = []
    root_path = ""
    scratch_file = ""

  [plugins."io.containerd.snapshotter.v1.devmapper"]
    async_remove = false
    base_image_size = ""
    discard_blocks = false
    fs_options = ""
    fs_type = ""
    pool_name = ""
    root_path = ""

  [plugins."io.containerd.snapshotter.v1.native"]
    root_path = ""

  [plugins."io.containerd.snapshotter.v1.overlayfs"]
    mount_options = []
    root_path = ""
    sync_remove = false
    upperdir_label = false

  [plugins."io.containerd.snapshotter.v1.zfs"]
    root_path = ""

  [plugins."io.containerd.tracing.processor.v1.otlp"]

  [plugins."io.containerd.transfer.v1.local"]
    config_path = ""
    max_concurrent_downloads = 3
    max_concurrent_uploaded_layers = 3

    [[plugins."io.containerd.transfer.v1.local".unpack_config]]
      differ = ""
      platform = "linux/amd64"
      snapshotter = "overlayfs"

[proxy_plugins]

[stream_processors]

  [stream_processors."io.containerd.ocicrypt.decoder.v1.tar"]
    accepts = ["application/vnd.oci.image.layer.v1.tar+encrypted"]
    args = ["--decryption-keys-path", "/etc/containerd/ocicrypt/keys"]
    env = ["OCICRYPT_KEYPROVIDER_CONFIG=/etc/containerd/ocicrypt/ocicrypt_keyprovider.conf"]
    path = "ctd-decoder"
    returns = "application/vnd.oci.image.layer.v1.tar"

  [stream_processors."io.containerd.ocicrypt.decoder.v1.tar.gzip"]
    accepts = ["application/vnd.oci.image.layer.v1.tar+gzip+encrypted"]
    args = ["--decryption-keys-path", "/etc/containerd/ocicrypt/keys"]
    env = ["OCICRYPT_KEYPROVIDER_CONFIG=/etc/containerd/ocicrypt/ocicrypt_keyprovider.conf"]
    path = "ctd-decoder"
    returns = "application/vnd.oci.image.layer.v1.tar+gzip"

[timeouts]
  "io.containerd.timeout.bolt.open" = "0s"
  "io.containerd.timeout.metrics.shimstats" = "2s"
  "io.containerd.timeout.shim.cleanup" = "5s"
  "io.containerd.timeout.shim.load" = "5s"
  "io.containerd.timeout.shim.shutdown" = "3s"
  "io.containerd.timeout.task.state" = "2s"

[ttrpc]
  address = ""
  gid = 0
  uid = 0
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service � /usr/lib/systemd/system/containerd.service.
� containerd.service - containerd container runtime
     Loaded: loaded (/usr/lib/systemd/system/containerd.service; enabled; preset: disabled)
     Active: active (running) since Tue 2024-11-19 00:17:47 UTC; 10s ago
       Docs: https://containerd.io
   Main PID: 3249 (containerd)
      Tasks: 9
     Memory: 17.3M
        CPU: 122ms
     CGroup: /system.slice/containerd.service
              3249 /usr/bin/containerd

Nov 19 00:17:47 guwdfocwfcrhe01 containerd[3249]: time="2024-11-19T00:17:47.801693798Z" level=info msg="Start subscribing containerd event"
Nov 19 00:17:47 guwdfocwfcrhe01 containerd[3249]: time="2024-11-19T00:17:47.801764950Z" level=info msg="Start recovering state"
Nov 19 00:17:47 guwdfocwfcrhe01 containerd[3249]: time="2024-11-19T00:17:47.801874150Z" level=info msg="Start event monitor"
Nov 19 00:17:47 guwdfocwfcrhe01 containerd[3249]: time="2024-11-19T00:17:47.801897072Z" level=info msg="Start snapshots syncer"
Nov 19 00:17:47 guwdfocwfcrhe01 containerd[3249]: time="2024-11-19T00:17:47.801915136Z" level=info msg="Start cni network conf syncer for default"
Nov 19 00:17:47 guwdfocwfcrhe01 containerd[3249]: time="2024-11-19T00:17:47.801931169Z" level=info msg="Start streaming server"
Nov 19 00:17:47 guwdfocwfcrhe01 containerd[3249]: time="2024-11-19T00:17:47.801917120Z" level=info msg=serving... address=/run/containerd/containerd.sock.ttrpc
Nov 19 00:17:47 guwdfocwfcrhe01 containerd[3249]: time="2024-11-19T00:17:47.802099411Z" level=info msg=serving... address=/run/containerd/containerd.sock
Nov 19 00:17:47 guwdfocwfcrhe01 containerd[3249]: time="2024-11-19T00:17:47.802182334Z" level=info msg="containerd successfully booted in 0.041354s"
Nov 19 00:17:47 guwdfocwfcrhe01 systemd[1]: Started containerd container runtime.
==================================================
2024-11-19 00:17:58 - Swap already disabled
==================================================
==================================================
2024-11-19 00:17:58 - Installing kernel headers
==================================================
Last metadata expiration check: 0:00:44 ago on Tue 19 Nov 2024 12:17:16 AM UTC.
Dependencies resolved.
========================================================================================================================================================================================================================================================================================
 Package                                                           Architecture                                       Version                                                              Repository                                                                              Size
========================================================================================================================================================================================================================================================================================
Installing:
 kernel-devel                                                      x86_64                                             5.14.0-503.14.1.el9_5                                                rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                              22 M
Installing dependencies:
 bison                                                             x86_64                                             3.7.4-5.el9                                                          rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                             947 k
 elfutils-libelf-devel                                             x86_64                                             0.191-4.el9                                                          rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                              24 k
 flex                                                              x86_64                                             2.6.4-9.el9                                                          rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                             318 k
 libzstd-devel                                                     x86_64                                             1.5.1-2.el9                                                          rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                              49 k
 openssl-devel                                                     x86_64                                             1:3.2.2-6.el9_5                                                      rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                             4.4 M
 zlib-devel                                                        x86_64                                             1.2.11-40.el9                                                        rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                              47 k

Transaction Summary
========================================================================================================================================================================================================================================================================================
Install  7 Packages

Total download size: 28 M
Installed size: 77 M
Downloading Packages:
(1/7): libzstd-devel-1.5.1-2.el9.x86_64.rpm                                                                                                                                                                                                             351 kB/s |  49 kB     00:00
(2/7): zlib-devel-1.2.11-40.el9.x86_64.rpm                                                                                                                                                                                                              982 kB/s |  47 kB     00:00
(3/7): flex-2.6.4-9.el9.x86_64.rpm                                                                                                                                                                                                                      1.5 MB/s | 318 kB     00:00
(4/7): elfutils-libelf-devel-0.191-4.el9.x86_64.rpm                                                                                                                                                                                                     543 kB/s |  24 kB     00:00
(5/7): bison-3.7.4-5.el9.x86_64.rpm                                                                                                                                                                                                                     3.5 MB/s | 947 kB     00:00
(6/7): openssl-devel-3.2.2-6.el9_5.x86_64.rpm                                                                                                                                                                                                            22 MB/s | 4.4 MB     00:00
(7/7): kernel-devel-5.14.0-503.14.1.el9_5.x86_64.rpm                                                                                                                                                                                                     34 MB/s |  22 MB     00:00
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                                                                    27 MB/s |  28 MB     00:01
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                                                                1/1
  Installing       : openssl-devel-1:3.2.2-6.el9_5.x86_64                                                                                                                                                                                                                           1/7
  Installing       : zlib-devel-1.2.11-40.el9.x86_64                                                                                                                                                                                                                                2/7
  Installing       : flex-2.6.4-9.el9.x86_64                                                                                                                                                                                                                                        3/7
  Installing       : libzstd-devel-1.5.1-2.el9.x86_64                                                                                                                                                                                                                               4/7
  Installing       : elfutils-libelf-devel-0.191-4.el9.x86_64                                                                                                                                                                                                                       5/7
  Installing       : bison-3.7.4-5.el9.x86_64                                                                                                                                                                                                                                       6/7
  Installing       : kernel-devel-5.14.0-503.14.1.el9_5.x86_64                                                                                                                                                                                                                      7/7
  Running scriptlet: kernel-devel-5.14.0-503.14.1.el9_5.x86_64                                                                                                                                                                                                                      7/7
  Verifying        : bison-3.7.4-5.el9.x86_64                                                                                                                                                                                                                                       1/7
  Verifying        : libzstd-devel-1.5.1-2.el9.x86_64                                                                                                                                                                                                                               2/7
  Verifying        : flex-2.6.4-9.el9.x86_64                                                                                                                                                                                                                                        3/7
  Verifying        : zlib-devel-1.2.11-40.el9.x86_64                                                                                                                                                                                                                                4/7
  Verifying        : elfutils-libelf-devel-0.191-4.el9.x86_64                                                                                                                                                                                                                       5/7
  Verifying        : openssl-devel-1:3.2.2-6.el9_5.x86_64                                                                                                                                                                                                                           6/7
  Verifying        : kernel-devel-5.14.0-503.14.1.el9_5.x86_64                                                                                                                                                                                                                      7/7

Installed:
  bison-3.7.4-5.el9.x86_64       elfutils-libelf-devel-0.191-4.el9.x86_64       flex-2.6.4-9.el9.x86_64       kernel-devel-5.14.0-503.14.1.el9_5.x86_64       libzstd-devel-1.5.1-2.el9.x86_64       openssl-devel-1:3.2.2-6.el9_5.x86_64       zlib-devel-1.2.11-40.el9.x86_64

Complete!
==================================================
2024-11-19 00:18:43 - Loading kernel modules
==================================================
==================================================
2024-11-19 00:18:44 - Ensuring kernel modules load on boot
==================================================
==================================================
2024-11-19 00:18:44 - Setting system configurations
==================================================
* Applying /usr/lib/sysctl.d/10-default-yama-scope.conf ...
* Applying /usr/lib/sysctl.d/50-coredump.conf ...
* Applying /usr/lib/sysctl.d/50-default.conf ...
* Applying /usr/lib/sysctl.d/50-libkcapi-optmem_max.conf ...
* Applying /usr/lib/sysctl.d/50-pid-max.conf ...
* Applying /usr/lib/sysctl.d/50-redhat.conf ...
* Applying /etc/sysctl.d/60-gce-network-security.conf ...
* Applying /etc/sysctl.d/99-sysctl.conf ...
* Applying /etc/sysctl.d/kubernetes.conf ...
* Applying /etc/sysctl.conf ...
kernel.yama.ptrace_scope = 0
kernel.core_pattern = |/usr/lib/systemd/systemd-coredump %P %u %g %s %t %c %h
kernel.core_pipe_limit = 16
fs.suid_dumpable = 2
kernel.sysrq = 16
kernel.core_uses_pid = 1
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.eth0.rp_filter = 2
net.ipv4.conf.lo.rp_filter = 2
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.eth0.accept_source_route = 0
net.ipv4.conf.lo.accept_source_route = 0
net.ipv4.conf.default.promote_secondaries = 1
net.ipv4.conf.eth0.promote_secondaries = 1
net.ipv4.conf.lo.promote_secondaries = 1
net.ipv4.ping_group_range = 0 2147483647
net.core.default_qdisc = fq_codel
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
fs.protected_regular = 1
fs.protected_fifos = 1
net.core.optmem_max = 81920
kernel.pid_max = 4194304
kernel.kptr_restrict = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.eth0.rp_filter = 1
net.ipv4.conf.lo.rp_filter = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 1
net.ipv4.conf.default.secure_redirects = 1
net.ipv4.ip_forward = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
kernel.randomize_va_space = 2
kernel.panic = 10
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
==================================================
2024-11-19 00:18:44 - Configuring firewall rules
==================================================
FirewallD is not running
FirewallD is not running
FirewallD is not running
FirewallD is not running
FirewallD is not running
FirewallD is not running
FirewallD is not running
FirewallD is not running
==================================================
2024-11-19 00:18:47 - Setting SELinux to permissive mode
==================================================
setenforce: SELinux is disabled
==================================================
2024-11-19 00:18:47 - Adding Kubernetes repository
==================================================
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
==================================================
2024-11-19 00:18:47 - Installing Kubernetes components
==================================================
Kubernetes                                                                                                                                                                                                                                              128 kB/s |  37 kB     00:00
Dependencies resolved.
========================================================================================================================================================================================================================================================================================
 Package                                                             Architecture                                        Version                                                          Repository                                                                               Size
========================================================================================================================================================================================================================================================================================
Installing:
 kubeadm                                                             x86_64                                              1.28.15-150500.1.1                                               kubernetes                                                                              9.8 M
 kubectl                                                             x86_64                                              501.0.0-1                                                        google-cloud-sdk                                                                         68 M
 kubelet                                                             x86_64                                              1.28.15-150500.1.1                                               kubernetes                                                                               19 M
Installing dependencies:
 conntrack-tools                                                     x86_64                                              1.4.7-2.el9                                                      rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                              239 k
 cri-tools                                                           x86_64                                              1.28.0-150500.1.1                                                kubernetes                                                                              8.1 M
 kubernetes-cni                                                      x86_64                                              1.2.0-150500.2.1                                                 kubernetes                                                                              6.2 M
 libnetfilter_cthelper                                               x86_64                                              1.0.0-22.el9                                                     rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                               26 k
 libnetfilter_cttimeout                                              x86_64                                              1.0.0-19.el9                                                     rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                               25 k
 libnetfilter_queue                                                  x86_64                                              1.0.5-1.el9                                                      rhui-rhel-9-for-x86_64-appstream-rhui-rpms                                               31 k

Transaction Summary
========================================================================================================================================================================================================================================================================================
Install  9 Packages

Total download size: 112 M
Installed size: 537 M
Downloading Packages:
(1/9): kubeadm-1.28.15-150500.1.1.x86_64.rpm                                                                                                                                                                                                             29 MB/s | 9.8 MB     00:00
(2/9): cri-tools-1.28.0-150500.1.1.x86_64.rpm                                                                                                                                                                                                            20 MB/s | 8.1 MB     00:00
(3/9): kubernetes-cni-1.2.0-150500.2.1.x86_64.rpm                                                                                                                                                                                                        30 MB/s | 6.2 MB     00:00
(4/9): kubelet-1.28.15-150500.1.1.x86_64.rpm                                                                                                                                                                                                             45 MB/s |  19 MB     00:00
(5/9): libnetfilter_cthelper-1.0.0-22.el9.x86_64.rpm                                                                                                                                                                                                    110 kB/s |  26 kB     00:00
(6/9): 133085deca39969b5fe416d4f5aa5c4a9d63f19c27ea7bd65b4ba8c7ebc4059f-kubectl-501.0.0-1.x86_64.rpm                                                                                                                                                     45 MB/s |  68 MB     00:01
(7/9): libnetfilter_cttimeout-1.0.0-19.el9.x86_64.rpm                                                                                                                                                                                                    33 kB/s |  25 kB     00:00
(8/9): libnetfilter_queue-1.0.5-1.el9.x86_64.rpm                                                                                                                                                                                                         44 kB/s |  31 kB     00:00
(9/9): conntrack-tools-1.4.7-2.el9.x86_64.rpm                                                                                                                                                                                                           1.2 MB/s | 239 kB     00:00
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                                                                    60 MB/s | 112 MB     00:01
Kubernetes                                                                                                                                                                                                                                               15 kB/s | 1.7 kB     00:00
Importing GPG key 0x9A296436:
 Userid     : "isv:kubernetes OBS Project <isv:kubernetes@build.opensuse.org>"
 Fingerprint: DE15 B144 86CD 377B 9E87 6E1A 2346 54DA 9A29 6436
 From       : https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                                                                1/1
  Installing       : kubernetes-cni-1.2.0-150500.2.1.x86_64                                                                                                                                                                                                                         1/9
  Installing       : libnetfilter_queue-1.0.5-1.el9.x86_64                                                                                                                                                                                                                          2/9
  Installing       : libnetfilter_cttimeout-1.0.0-19.el9.x86_64                                                                                                                                                                                                                     3/9
  Installing       : libnetfilter_cthelper-1.0.0-22.el9.x86_64                                                                                                                                                                                                                      4/9
  Installing       : conntrack-tools-1.4.7-2.el9.x86_64                                                                                                                                                                                                                             5/9
  Running scriptlet: conntrack-tools-1.4.7-2.el9.x86_64                                                                                                                                                                                                                             5/9
  Installing       : kubelet-1.28.15-150500.1.1.x86_64                                                                                                                                                                                                                              6/9
  Running scriptlet: kubelet-1.28.15-150500.1.1.x86_64                                                                                                                                                                                                                              6/9
  Installing       : cri-tools-1.28.0-150500.1.1.x86_64                                                                                                                                                                                                                             7/9
  Installing       : kubectl-501.0.0-1.x86_64                                                                                                                                                                                                                                       8/9
  Installing       : kubeadm-1.28.15-150500.1.1.x86_64                                                                                                                                                                                                                              9/9
  Running scriptlet: kubeadm-1.28.15-150500.1.1.x86_64                                                                                                                                                                                                                              9/9
  Verifying        : kubectl-501.0.0-1.x86_64                                                                                                                                                                                                                                       1/9
  Verifying        : cri-tools-1.28.0-150500.1.1.x86_64                                                                                                                                                                                                                             2/9
  Verifying        : kubeadm-1.28.15-150500.1.1.x86_64                                                                                                                                                                                                                              3/9
  Verifying        : kubelet-1.28.15-150500.1.1.x86_64                                                                                                                                                                                                                              4/9
  Verifying        : kubernetes-cni-1.2.0-150500.2.1.x86_64                                                                                                                                                                                                                         5/9
  Verifying        : libnetfilter_cthelper-1.0.0-22.el9.x86_64                                                                                                                                                                                                                      6/9
  Verifying        : libnetfilter_cttimeout-1.0.0-19.el9.x86_64                                                                                                                                                                                                                     7/9
  Verifying        : libnetfilter_queue-1.0.5-1.el9.x86_64                                                                                                                                                                                                                          8/9
  Verifying        : conntrack-tools-1.4.7-2.el9.x86_64                                                                                                                                                                                                                             9/9

Installed:
  conntrack-tools-1.4.7-2.el9.x86_64            cri-tools-1.28.0-150500.1.1.x86_64       kubeadm-1.28.15-150500.1.1.x86_64    kubectl-501.0.0-1.x86_64    kubelet-1.28.15-150500.1.1.x86_64    kubernetes-cni-1.2.0-150500.2.1.x86_64    libnetfilter_cthelper-1.0.0-22.el9.x86_64
  libnetfilter_cttimeout-1.0.0-19.el9.x86_64    libnetfilter_queue-1.0.5-1.el9.x86_64

Complete!
Created symlink /etc/systemd/system/multi-user.target.wants/kubelet.service � /usr/lib/systemd/system/kubelet.service.
==================================================
2024-11-19 00:19:19 - Initializing Kubernetes master node
==================================================
I1119 00:19:19.563362   23011 version.go:256] remote version is much newer: v1.31.2; falling back to: stable-1.28
[init] Using Kubernetes version: v1.28.15
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
W1119 00:19:27.240156   23011 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [guwdfocwfcrhe01 kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.250.56.11]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [guwdfocwfcrhe01 localhost] and IPs [10.250.56.11 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [guwdfocwfcrhe01 localhost] and IPs [10.250.56.11 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 6.501749 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node guwdfocwfcrhe01 as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node guwdfocwfcrhe01 as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: czhd0h.oqo7l4aq233ypx0k
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.250.56.11:6443 --token czhd0h.oqo7l4aq233ypx0k \
        --discovery-token-ca-cert-hash sha256:ca00f048825dcf214fd374bf480c7cef785f11697f42272903c949ad5ed2d873
==================================================
2024-11-19 00:19:43 - Setting up kubeconfig for root
==================================================
==================================================
2024-11-19 00:19:43 - Deploying Flannel pod network
==================================================
namespace/kube-flannel created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
serviceaccount/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds created
==================================================
2024-11-19 00:19:44 - Enabling scheduling on the master node
==================================================
error: taint "node-role.kubernetes.io/master" not found
==================================================
2024-11-19 00:19:44 - Scheduling already enabled on the master node
==================================================
==================================================
2024-11-19 00:19:44 - Kubernetes installation and deployment completed successfully
==================================================
==================================================
2024-11-19 00:19:44 - Checking for Helm installation
==================================================
==================================================
2024-11-19 00:19:44 - Helm not found. Installing Helm...
==================================================
Downloading https://get.helm.sh/helm-v3.16.3-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
helm not found. Is /usr/local/bin on your $PATH?
Failed to install helm
        For support, go to https://github.com/helm/helm.
==================================================
2024-11-19 00:19:46 - Checking for Helmfile installation
==================================================
==================================================
2024-11-19 00:19:46 - Helmfile not found. Installing Helmfile...
==================================================
--2024-11-19 00:19:46--  https://github.com/helmfile/helmfile/releases/download/v0.169.1/helmfile_0.169.1_linux_amd64.tar.gz
Resolving github.com (github.com)... 140.82.116.4
Connecting to github.com (github.com)|140.82.116.4|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://objects.githubusercontent.com/github-production-release-asset-2e65be/474521466/17a11a05-611d-4c36-8046-fd7657901acd?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20241119%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241119T001947Z&X-Amz-Expires=300&X-Amz-Signature=ee0f61d47f93e39c0a3070e113e9388dd97a833fdfb32287b8e0b6b3424b1926&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dhelmfile_0.169.1_linux_amd64.tar.gz&response-content-type=application%2Foctet-stream [following]
--2024-11-19 00:19:47--  https://objects.githubusercontent.com/github-production-release-asset-2e65be/474521466/17a11a05-611d-4c36-8046-fd7657901acd?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20241119%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241119T001947Z&X-Amz-Expires=300&X-Amz-Signature=ee0f61d47f93e39c0a3070e113e9388dd97a833fdfb32287b8e0b6b3424b1926&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dhelmfile_0.169.1_linux_amd64.tar.gz&response-content-type=application%2Foctet-stream
Resolving objects.githubusercontent.com (objects.githubusercontent.com)... 185.199.110.133, 185.199.108.133, 185.199.109.133, ...
Connecting to objects.githubusercontent.com (objects.githubusercontent.com)|185.199.110.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 31789846 (30M) [application/octet-stream]
Saving to: helmfile_0.169.1_linux_amd64.tar.gz

helmfile_0.169.1_linux_amd64.tar.gz                                   100%[=========================================================================================================================================================================>]  30.32M  --.-KB/s    in 0.1s

2024-11-19 00:19:47 (240 MB/s) - helmfile_0.169.1_linux_amd64.tar.gz saved [31789846/31789846]

LICENSE
README-zh_CN.md
README.md
helmfile
==================================================
2024-11-19 00:19:48 - Helm and Helmfile installation check completed successfully
================================================== 
```
## Notes
- **Customizations:** Update `POD_NETWORK_CIDR` and `K8S_VERSION` variables in the script to match your specific requirements.
- **Logs:** Outputs details for each step, making it easier to debug if an error occurs.
- **Error Handling:** If critical components fail (e.g., `kubeadm init`), the script exits with an error message.

## Placeholder for Future Enhancements
- Support for additional Kubernetes pod networks (e.g., Calico).
- Option to configure worker nodes and join them to the cluster.
- Automated generation of Helmfile configurations.
