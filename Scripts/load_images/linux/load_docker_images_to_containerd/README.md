# Load Docker Images for IBI WebFOCUS

## Overview

This script automates the process of loading IBI WebFOCUS container images from a tar file into the `containerd` runtime. Since Kubernetes 1.25 and later removed Docker support (`dockershim`), Kubernetes clusters now use `containerd` or other CRI-compatible runtimes. This script simplifies the necessary steps to ensure that these container images are properly loaded and available for Kubernetes deployments.

## Purpose

- Extract container images from a tar file downloaded from [TIBCO Downloads](https://www.tibco.com/downloads).
- Load the images into Docker or Podman.
- Transfer the images from Docker/Podman to `containerd`.
- Verify that the images are successfully loaded into `containerd`.
- Optionally, delete existing images from `containerd`.

## Prerequisites

- A Kubernetes environment using `containerd`.
- `docker` or `podman` installed.
- `ctr` (containerd CLI) installed.
- `sudo` privileges to manage `containerd` images.
- The `IBI_wfce_images_<version>.tar` file must be placed in the same directory as the script.

## Related WebFOCUS CE Documentation

This script consolidates two distinct steps documented in the WebFOCUS CE documentation. Below are links to the relevant sections:

- **Downloading the shipped images:** [WebFOCUS CE Documentation - Downloading Images](https://docs.tibco.com/pub/wfce/1.3.3/doc/html/Default.htm#Installation-and-Deployment-Guide/Using_images_for_docker.htm#Download)
- **Copying container images into the `containerd` runtime:** [WebFOCUS CE Documentation - Copying Images](https://docs.tibco.com/pub/wfce/1.3.3/doc/html/Default.htm#Installation-and-Deployment-Guide/Requirements_and_Prerequisites.htm#Containe)

## How to Use It

1. Copy or download `load_wfce_image.sh` and place it in the same directory as the `IBI_wfce_images_*.tar` file.
2. Ensure that all prerequisites listed above are met.
3. Make the script executable by running:
   ```sh
   chmod +x load_wfce_image.sh
   ```
4. This script requires `sudo` privileges, so ensure your user has permission to run `sudo` commands.
5. This script assumes you want to extract images from the tar file and copy them into `containerd` running on the same Linux machine.

## When to Use This Script

Use this script if you need to:

1. Load IBI WebFOCUS container images into your local `containerd` runtime for Kubernetes.
2. Automate the transfer of images from Docker/Podman to `containerd`.
3. Delete existing WebFOCUS images from `containerd` before loading new ones.

If you intend to push these images to an image registry, **you do not need to run this script**. Instead, load them into Docker/Podman and push them directly to the registry.


## Demo 

![Demo](load_wfce_image.gif)

## Usage

### Basic Commands

```sh
# Display help information
./load_wfce_image.sh -h

# Load images into containerd
sudo ./load_wfce_image.sh

# Load images in non-interactive mode
sudo ./load_wfce_image.sh -y

# Enable verbose output
sudo ./load_wfce_image.sh -v

# Delete images from containerd
sudo ./load_wfce_image.sh --delete-images
```

### Options

| Option            | Description                                              |
|------------------|---------------------------------------------------------|
| `-y`             | Automatically confirm all prompts (non-interactive mode) |
| `-v`             | Enable verbose mode, displaying executed commands        |
| `--delete-images`| Delete existing WebFOCUS images from `containerd`        |
| `--no-color`     | Disable colored output                                   |
| `--no-log`       | Do not log output to a file                              |
| `-h`, `--help`   | Display help information                                 |

## Sample Output

### Help Command

```
$ sudo ./load_wfce_image.sh -h
Usage: ./load_wfce_image.sh [options]

This script loads container images built by the IBI WebFOCUS team from a tar file and imports them into `containerd`.

Options:
  -y                Automatically confirm all prompts (non-interactive mode)
  -v                Enable verbose mode, displaying the commands being executed
  --delete-images   Delete existing images from `containerd`
  --no-color        Disable colored output
  --no-log          Do not log output to a file
  -h, --help        Display this help message and exit
```

### Successful Execution

<details>

<summary>Click to see output </summary>

```
$ sudo ./load_wfce_image.sh
[2025-02-25 02:58:43] Extracted version from tar file: 1.3.3
[2025-02-25 02:58:43] ===============================
[2025-02-25 02:58:43] Checking container runtime version
[2025-02-25 02:58:43] ===============================
[2025-02-25 02:58:43] docker version: Docker version 24.0.7, build 24.0.7-0ubuntu2~22.04.1
[2025-02-25 02:58:43] ctr version: Client:
  Version:  1.7.12
  Revision: 
  Go version: go1.21.1

Server:
  Version:  1.7.12
  Revision: 
  UUID: fba7f822-7676-465a-b039-4b6eb3eb7d0b
Found tar file: ./IBI_wfce_images_1.3.3.tar. Do you want to proceed with loading the container images? (y/n) y
[2025-02-25 02:58:55] ===============================
[2025-02-25 02:58:55] Loading container images from tar file
[2025-02-25 02:58:55] ===============================
Loaded image: ibi2020/webfocus:wfc-9.3-1.3.3
Loaded image: ibi2020/webfocus:wfs-9.3-1.3.3
Loaded image: ibi2020/webfocus:wfs-etc-9.3-1.3.3
Loaded image: ibi2020/webfocus:cm-9.3-1.3.3
[2025-02-25 03:00:32] ===============================
[2025-02-25 03:00:32] Listing container images with label 'webfocusce_version'
[2025-02-25 03:00:32] ===============================
[2025-02-25 03:00:32] ibi2020/webfocus:wfc-9.3-1.3.3
[2025-02-25 03:00:32] ibi2020/webfocus:cm-9.3-1.3.3
[2025-02-25 03:00:32] ibi2020/webfocus:wfs-etc-9.3-1.3.3
[2025-02-25 03:00:32] ibi2020/webfocus:wfs-9.3-1.3.3
Do you want to proceed with loading the container images into containerd? (y/n) y
[2025-02-25 03:01:44] ===============================
[2025-02-25 03:01:44] Loading container images into containerd with version 1.3.3
[2025-02-25 03:01:44] ===============================
[2025-02-25 03:01:44] Loading ibi2020/webfocus:wfc-9.3-1.3.3 into containerd...
unpacking docker.io/ibi2020/webfocus:wfc-9.3-1.3.3 (sha256:a2a385f08bb7a4b32e9c9da6aa2451f9f2641dc48fcdad2e31de849b84b944cd)...done
[2025-02-25 03:03:59] Loading ibi2020/webfocus:cm-9.3-1.3.3 into containerd...
unpacking docker.io/ibi2020/webfocus:cm-9.3-1.3.3 (sha256:623a6b6aed6edc93c56256cb1bb9e96a05d127c0673a88d4bcd9a31e0f1cc61b)...done
[2025-02-25 03:04:09] Loading ibi2020/webfocus:wfs-etc-9.3-1.3.3 into containerd...
unpacking docker.io/ibi2020/webfocus:wfs-etc-9.3-1.3.3 (sha256:1ff984e2e416fc8425301e67f427381b103b0c894ca2992187e6aaf733d0ab11)...done
[2025-02-25 03:06:18] Loading ibi2020/webfocus:wfs-9.3-1.3.3 into containerd...
unpacking docker.io/ibi2020/webfocus:wfs-9.3-1.3.3 (sha256:02b38aefe51863fc5e3abcad0a3c945b56bcdfe0071e63ddde05bac3e0eff25a)...done
[2025-02-25 03:07:41] ===============================
[2025-02-25 03:07:41] Verifying images loaded into containerd
[2025-02-25 03:07:41] ===============================
[2025-02-25 03:07:42] Image ibi2020/webfocus:wfc-9.3-1.3.3 successfully found in containerd.
[2025-02-25 03:07:43] Image ibi2020/webfocus:cm-9.3-1.3.3 successfully found in containerd.
[2025-02-25 03:07:43] Image ibi2020/webfocus:wfs-etc-9.3-1.3.3 successfully found in containerd.
[2025-02-25 03:07:44] Image ibi2020/webfocus:wfs-9.3-1.3.3 successfully found in containerd.
[2025-02-25 03:07:44] ===============================
[2025-02-25 03:07:44] Script execution completed
[2025-02-25 03:07:44] ===============================
```

</details>

### Deleting Images from `containerd`

<details>

<summary>Click to see output </summary>

```
$ sudo ./load_wfce_image.sh --delete-images
[2025-02-25 03:17:02] Extracted version from tar file: 1.3.3
[2025-02-25 03:17:02] ===============================
[2025-02-25 03:17:02] Deleting container images in containerd with label 'webfocus' and version 1.3.3
[2025-02-25 03:17:02] ===============================
[2025-02-25 03:17:02] The following 'webfocus' images with version 1.3.3 will be deleted:
docker.io/ibi2020/webfocus:cm-9.3-1.3.3
docker.io/ibi2020/webfocus:wfc-9.3-1.3.3
docker.io/ibi2020/webfocus:wfs-9.3-1.3.3
docker.io/ibi2020/webfocus:wfs-etc-9.3-1.3.3
Are you sure you want to delete these images? (y/n) y
[2025-02-25 03:17:12] Deleting docker.io/ibi2020/webfocus:cm-9.3-1.3.3 from containerd...
docker.io/ibi2020/webfocus:cm-9.3-1.3.3
[2025-02-25 03:17:12] Successfully deleted docker.io/ibi2020/webfocus:cm-9.3-1.3.3.
[2025-02-25 03:17:12] Deleting docker.io/ibi2020/webfocus:wfc-9.3-1.3.3 from containerd...
docker.io/ibi2020/webfocus:wfc-9.3-1.3.3
[2025-02-25 03:17:12] Successfully deleted docker.io/ibi2020/webfocus:wfc-9.3-1.3.3.
[2025-02-25 03:17:12] Deleting docker.io/ibi2020/webfocus:wfs-9.3-1.3.3 from containerd...
docker.io/ibi2020/webfocus:wfs-9.3-1.3.3
[2025-02-25 03:17:12] Successfully deleted docker.io/ibi2020/webfocus:wfs-9.3-1.3.3.
[2025-02-25 03:17:12] Deleting docker.io/ibi2020/webfocus:wfs-etc-9.3-1.3.3 from containerd...
docker.io/ibi2020/webfocus:wfs-etc-9.3-1.3.3
[2025-02-25 03:17:12] Successfully deleted docker.io/ibi2020/webfocus:wfs-etc-9.3-1.3.3.
[2025-02-25 03:17:12] ===============================
[2025-02-25 03:17:12] Containerd webfocus image deletion process completed
[2025-02-25 03:17:12] ===============================
```

</details>

## Logging

By default, the script logs its output to a file named `load_docker_images_YYYYMMDD_HHMMSS.log`. You can disable logging using the `--no-log` option.

## Notes

- If you are running this on Kubernetes 1.25 or later, ensure that your cluster uses `containerd`.
- Ensure that `IBI_wfce_images_<version>.tar` is in the same directory as the script before execution.
- If you plan to push images to an external registry, **do not use this script**. Instead, load the images into Docker/Podman and push them directly.

## License

This script is provided "as-is" without any warranty. Use at your own risk.