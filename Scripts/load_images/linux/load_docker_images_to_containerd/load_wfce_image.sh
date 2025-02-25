#!/bin/bash

# Function to print banner with optional coloring and timestamp
print_banner() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    if [ "$DISABLE_COLOR" = false ]; then
        echo -e "\033[0;32m[$timestamp] ===============================\033[0m"
        echo -e "\033[0;32m[$timestamp] $1\033[0m"
        echo -e "\033[0;32m[$timestamp] ===============================\033[0m"
    else
        echo "[$timestamp] ==============================="
        echo "[$timestamp] $1"
        echo "[$timestamp] ==============================="
    fi
}

# Function to print messages with optional coloring and timestamp
print_message() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    if [ "$DISABLE_COLOR" = false ]; then
        echo -e "\033[0;32m[$timestamp] $1\033[0m"
    else
        echo "[$timestamp] $1"
    fi
}

# Function to display help message
print_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "This script loads container images built by IBI WebFOCUS team from a tar file and imports them into containerd."
    echo ""
    echo "Options:"
    echo "  -y                Automatically confirm all prompts (non-interactive mode)"
    echo "  -v                Enable verbose mode, displaying the commands being executed"
    echo "  --delete-images   Delete existing images from containerd"
    echo "  --no-color        Disable colored output"
    echo "  --no-log          Do not log output to a file"
    echo "  -h, --help        Display this help message and exit"
}

# Extract version (x.y.z) from tar filename
extract_version_from_tar() {
    TAR_FILE=$(find . -name 'IBI_wfce_images_*.tar' -print -quit)
    if [[ -n "$TAR_FILE" ]]; then
        VERSION=$(echo "$TAR_FILE" | grep -oP '\d+\.\d+\.\d+' | head -1)
        if [[ -n "$VERSION" ]]; then
            print_message "Extracted version from tar file: $VERSION"
        else
            print_message "Unable to extract version from tar file. Please enter the version manually."
            read -p "Enter the version (x.y.z format): " VERSION
        fi
    else
        print_message "No tar file found. Please enter the version manually."
        read -p "Enter the version (x.y.z format): " VERSION
    fi
}


delete_containerd_images() {
    print_banner "Deleting container images in containerd with label 'webfocus' and version $VERSION"

    # List images that match 'webfocus' and version
    IMAGES_TO_DELETE=$(sudo ctr -n k8s.io images list -q | grep "webfocus" | grep -E "[-_]$VERSION$")

    if [ -z "$IMAGES_TO_DELETE" ]; then
        print_message "No container images matching 'webfocus' with version $VERSION found. Nothing to delete."
        return
    fi

    # Ask for confirmation before deleting images (unless AUTO_CONFIRM is enabled)
    if [ "$AUTO_CONFIRM" = false ]; then
        print_message "The following 'webfocus' images with version $VERSION will be deleted:"
        echo "$IMAGES_TO_DELETE"
        read -p "Are you sure you want to delete these images? (y/n) " response
        if [[ "$response" != "y" ]]; then
            print_message "User chose not to delete images. Exiting."
            return
        fi
    fi

    # Delete images
    for IMAGE in $IMAGES_TO_DELETE; do
        print_message "Deleting $IMAGE from containerd..."
        sudo ctr -n k8s.io images remove "$IMAGE"
        if [ $? -ne 0 ]; then
            print_message "Failed to delete image $IMAGE. Continuing with next image."
        else
            print_message "Successfully deleted $IMAGE."
        fi
    done

    print_banner "Containerd webfocus image deletion process completed"
}



# Parse -y, -v, -h, --no-color, and --no-log flags for non-interactive mode, verbose mode, help, disabling color, and disabling logging
AUTO_CONFIRM=false
VERBOSE=false
DISABLE_COLOR=false
DISABLE_LOG=false
LOG_FILE="load_docker_images_$(date +"%Y%m%d_%H%M%S").log"
# Parse script options: -y, -v, -h, --no-color, --no-log, --delete-images
DELETE_IMAGES=false  # Default: do not delete images
# Parse script options using `getopt`
OPTS=$(getopt -o yvh --long no-color,no-log,delete-images,help -n "$0" -- "$@")
if [ $? != 0 ]; then print_help; exit 1; fi
eval set -- "$OPTS"
while true; do
    case "$1" in
        -y)
            AUTO_CONFIRM=true
            DISABLE_COLOR=true
            shift
            ;;
        -v)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        --no-color)
            DISABLE_COLOR=true
            shift
            ;;
        --no-log)
            DISABLE_LOG=true
            shift
            ;;
        --delete-images)
            DELETE_IMAGES=true
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            print_help
            exit 1
            ;;
    esac
done

extract_version_from_tar


# If --delete-images flag is used, delete images and exit
if [ "$DELETE_IMAGES" = true ]; then
    delete_containerd_images
    exit 0
fi


# Log output to file unless logging is disabled
if [ "$DISABLE_LOG" = false ]; then
    exec > >(tee -a "$LOG_FILE") 2>&1
fi

# Check if script is run with sudo
if [ "$EUID" -ne 0 ] && [ "$AUTO_CONFIRM" = false ]; then
    print_message "It is recommended to run this script with sudo privileges. Do you want to continue? (y/n)"
    read response
    if [[ "$response" != "y" ]]; then
        print_message "User chose to stop. Exiting."
        exit 1
    fi
fi

# Function to run commands with optional verbose output
run_command() {
    if [ "$VERBOSE" = true ]; then
        print_message "Running: $*"
    fi
    eval "$*"
}

# Look for tar file
TAR_FILE=$(find . -name 'IBI_wfce_images_*.tar' -print -quit)
if [ -z "$TAR_FILE" ]; then
    print_message "No tar file found matching the pattern 'IBI_wfce_images_*.tar'. Proceeding without loading container images."
fi

# Check if Docker or Podman is installed
DOCKER_CMD=""
if command -v docker &> /dev/null; then
    DOCKER_CMD="docker"
elif command -v podman &> /dev/null; then
    DOCKER_CMD="podman"
else
    print_message "Neither Docker nor Podman command found. Please install Docker or Podman. Exiting."
    exit 1
fi

# Print Docker/Podman version
print_banner "Checking container runtime version"
DOCKER_VERSION_OUTPUT=$($DOCKER_CMD --version)
print_message "$DOCKER_CMD version: $DOCKER_VERSION_OUTPUT"

# Check if ctr is installed
if command -v ctr &> /dev/null; then
    CTR_VERSION_OUTPUT=$(sudo ctr version 2>&1)
    print_message "ctr version: $CTR_VERSION_OUTPUT"
else
    print_message "ctr command not found. Please install containerd. Exiting."
    exit 1
fi

# Ask for user permission to proceed with loading the tar file if not in auto-confirm mode
if [ "$AUTO_CONFIRM" = false ]; then
    read -p "Found tar file: $TAR_FILE. Do you want to proceed with loading the container images? (y/n) " response
    if [[ "$response" != "y" ]]; then
        print_message "User chose not to load container images. Skipping to next step."
    else
        # Load container images from tar file
        print_banner "Loading container images from tar file"
        run_command "$DOCKER_CMD load -i \"$TAR_FILE\" -q"
        if [ $? -ne 0 ]; then
            print_message "Failed to load container images from tar file. Exiting."
            exit 1
        fi
    fi
else
    # Auto-confirm loading container images from tar file
    print_banner "Loading container images from tar file"
    run_command "$DOCKER_CMD load -i \"$TAR_FILE\" -q"
    if [ $? -ne 0 ]; then
        print_message "Failed to load container images from tar file. Exiting."
        exit 1
    fi
fi

# List container images with label 'webfocusce_version'
print_banner "Listing container images with label 'webfocusce_version'"
# IMAGES=$($DOCKER_CMD images --filter "label=webfocusce_version" --format "{{.Repository}}:{{.Tag}}")
IMAGES=$($DOCKER_CMD images --filter "label=webfocusce_version" --format "{{.Repository}}:{{.Tag}}" | grep -E "[-_]$VERSION$")
if [ -z "$IMAGES" ]; then
    print_message "No container images found with label 'webfocusce_version'. Skipping loading into containerd."
    SKIP_CONTAINERD_LOAD=true
else
    SKIP_CONTAINERD_LOAD=false
fi


for IMAGE in $IMAGES; do
    print_message "$IMAGE"
done

# Ask for user permission to proceed with loading images into containerd if not in auto-confirm mode
if [ "$AUTO_CONFIRM" = false ] && [ "$SKIP_CONTAINERD_LOAD" = false ]; then
    read -p "Do you want to proceed with loading the container images into containerd? (y/n) " response
    if [[ "$response" != "y" ]]; then
        print_message "User chose not to load images into containerd. Skipping to next step."
    else
        # Load images into containerd, filtering by version
        print_banner "Loading container images into containerd with version $VERSION"
        for IMAGE in $IMAGES; do
            print_message "Loading $IMAGE into containerd..."
            run_command "$DOCKER_CMD save \"$IMAGE\" | sudo ctr -n k8s.io images import -"
            if [ $? -ne 0 ]; then
                print_message "Failed to load image $IMAGE into containerd. Continuing with next image."
            fi
        done
    fi
elif [ "$SKIP_CONTAINERD_LOAD" = false ]; then
    # Auto-confirm loading images into containerd
    # Load images into containerd
    print_banner "Loading container images into containerd"
    for IMAGE in $IMAGES; do
        print_message "Loading $IMAGE into containerd..."
        run_command "$DOCKER_CMD save \"$IMAGE\" | sudo ctr -n k8s.io images import -"
        if [ $? -ne 0 ]; then
            print_message "Failed to load image $IMAGE into containerd. Continuing with next image."
        fi
    done
fi

# Verify images loaded into containerd
print_banner "Verifying images loaded into containerd"
for IMAGE in $IMAGES; do
    IMAGE_NAME=$(echo "$IMAGE" | cut -d ':' -f 1)
    IMAGE_TAG=$(echo "$IMAGE" | cut -d ':' -f 2)
    IMAGE_LABEL="webfocusce_version"
    if ! sudo ctr -n k8s.io images list | grep -q "$IMAGE_NAME"; then
        print_message "Image $IMAGE_NAME:$IMAGE_TAG not found in containerd. Verification failed."
    else
        print_message "Image $IMAGE_NAME:$IMAGE_TAG successfully found in containerd."
    fi
done

print_banner "Script execution completed"
