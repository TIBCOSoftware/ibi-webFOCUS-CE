
## Choco Install Software Script

### Introduction

Welcome to the `install_software.ps1` script repository! This PowerShell script is designed to streamline the installation of essential software on a fresh Windows installation. Whether you're setting up a new machine or reconfiguring an existing one, this script automates the tedious process of installing commonly used software, ensuring that your environment is ready to go in no time.

### Objective

The primary objective of this script is to automate the installation of a suite of software that many users typically install when setting up a new Windows machine. The script currently covers a subset of software that is widely regarded as essential, but you can easily customize it to include additional tools as per your requirements.

### Introduction to Chocolatey

[Chocolatey](https://chocolatey.org/) is a popular package manager for Windows that simplifies the process of installing, updating, and managing software. It works similarly to package managers on Linux (like `apt` or `yum`), allowing users to install software packages from the command line. Chocolatey helps automate software installations, making it an invaluable tool for setting up a new machine or managing software on multiple systems.

**Key Benefits of Chocolatey:**

- **Automated Installations:** Easily install software with a single command.
- **Version Control:** Manage and update software versions effortlessly.
- **Customizable:** Supports a wide range of software packages, including open-source and commercial software.
- **Community-Driven:** Thousands of packages maintained by a robust community.

For more information, visit the [official Chocolatey website](https://chocolatey.org/).

### Using This Script

#### Prerequisites

- **Administrator Privileges:** This script requires administrative privileges to install software.
- **PowerShell:** Make sure you have PowerShell installed on your Windows machine.

#### Overview of `install_software.ps1`

This script is named `install_software.ps1` and is designed to install a predefined list of software using Chocolatey. It checks for each software's existence on the system and installs it only if it's not already installed, ensuring idempotency.

#### Software Installed by This Script

The script installs the following software:

- **Slack:** A popular messaging app for teams, providing real-time messaging, file sharing, and integrations with other tools.
- **Notepad++:** A free source code editor and Notepad replacement that supports several languages.
- **7zip:** A file archiver with a high compression ratio, supporting various file formats.
- **WinSCP:** A free SFTP, SCP, and FTP client for Windows, supporting file transfer and remote file management.
- **MobaXterm:** An enhanced terminal for Windows with an X11 server, tabbed SSH client, network tools, and more.
- **Sublime Text:** A sophisticated text editor for code, markup, and prose.
- **PuTTY:** A free and open-source terminal emulator, serial console, and network file transfer application.
- **Git:** A distributed version control system for tracking changes in source code during software development.
- **Python3:** A widely-used programming language known for its readability and support for multiple programming paradigms.
- **Conda (Miniconda):** A free, open-source package management system and environment management system for Python and other languages.
- **Visual Studio Code:** A source-code editor developed by Microsoft for Windows, Linux, and macOS.
- **JDK8:** Java Development Kit for developing and running Java applications.
- **Docker Desktop:** A containerization platform that simplifies the process of running and managing Docker containers on Windows.
- **Adobe Reader:** A free PDF viewer from Adobe, allowing you to open and interact with all types of PDF content.
- **Zoom:** A video conferencing tool that allows you to host and join meetings, webinars, and other online events.
- **WinRAR:** A powerful archiver and archive manager for Windows.
- **OpenSSH:** A suite of secure networking utilities based on the Secure Shell (SSH) protocol.
- **Citrix Workspace:** A digital workspace software platform that provides secure access to applications, desktops, and data.

#### Getting the Script from GitHub

You can easily download and run the script from GitHub. Follow these steps:

1. **Open PowerShell as Administrator:**
   - Right-click the Start button, and select `Windows PowerShell (Admin)`.

2. **Download and Execute the Script:**
   - Run the following command to download and execute the script:
     ```powershell
     iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/TIBCOSoftware/ibi-webFOCUS-CE/work-in-progress/Scripts/bootstrap/windows/install_software.ps1'))
     ```

#### Customizing the Script

The script is designed to be easily customizable. Here’s how you can modify it:

- **To Remove a Software Installation:**
  - Open the `install_software.ps1` file in any text editor.
  - Locate the `$tools` array in the script.
  - Comment out or remove the line corresponding to the software you don't want to install. For example:
    ```powershell
    # @{ ToolName = "putty"; ChocoName = "putty" }
    ```

- **To Add a New Software Installation:**
  - Visit the [Chocolatey Packages page](https://community.chocolatey.org/packages) to find the package name for the software you want to install.
  - Add a new line in the `$tools` array with the `ToolName` and `ChocoName`:
    ```powershell
    @{ ToolName = "newtool"; ChocoName = "newtool" }
    ```

### Troubleshooting and FAQs

- **Why does the script require administrator privileges?**
  - Installing software on Windows typically requires administrative rights to write to the Program Files directory and modify system settings.

- **What if a tool is already installed?**
  - The script is idempotent, meaning it checks if a tool is already installed and skips the installation if it is.

- **Can I add more software to the script?**
  - Absolutely! You can customize the script by adding more software to the `$tools` array using the Chocolatey package names.

- **Where can I find more Chocolatey packages?**
  - Visit the [Chocolatey Community Packages page](https://community.chocolatey.org/packages) to explore more software options.

### Getting Started

1. Clone the repository or download the script.
2. Open PowerShell with administrative privileges.
3. Run the script using the provided command.

