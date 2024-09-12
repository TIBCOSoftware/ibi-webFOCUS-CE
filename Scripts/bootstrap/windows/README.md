
## Choco Install Software Script

### Introduction

This PowerShell script is designed to streamline the installation of essential software on a fresh Windows installation.
Whether you're setting up a new machine or reconfiguring an existing one, this script automates the tedious process of installing commonly used software, ensuring that your environment is ready to go in no time.

#### Script in action (below is animated giff that shows how the script works)

![In Action](PowerShell_Choco_install.gif)

### Objective

The primary objective of this script is to automate the installation of a suite of software that many users typically install when setting up a new Windows machine. 
The script currently covers a subset of software that is widely regarded as essential, but you can easily customize it to include additional tools as per your requirements.
By default, script will ask for user input to install each software, but user can pass `-y` flag to avoid any prompts.

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

#### Running the Script with Administrator Privileges

1. **Open PowerShell as Administrator:**
   - Right-click the Start button, and select `Windows PowerShell (Admin)`.

2. **Download and Execute the Script:**
   - Run the following command to download and execute the script:
     ```powershell
     iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/TIBCOSoftware/ibi-webFOCUS-CE/work-in-progress/Scripts/bootstrap/windows/install_software.ps1'))
     ```
   - Run save script as above but pass ing "-y" to avoid any prompts:  
     Below command will download and execute the script passing `-y` flag so it will run without any prompts.
     ```powershell
     Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/TIBCOSoftware/ibi-webFOCUS-CE/work-in-progress/Scripts/bootstrap/windows/install_software.ps1' -OutFile 'install_software.ps1'; .\install_software.ps1 -y
     ```
3. **Review the Installation:**

#### Example Error Message if Not Run as Administrator

If you run the script without administrative privileges, you will see an error message like this:

```plaintext
PS C:\Windows\system32> iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/TIBCOSoftware/ibi-webFOCUS-CE/work-in-progress/Scripts/bootstrap/windows/install_software.ps1'))
Test-Admin : Script must be run as Administrator!
At line:70 char:1
+ Test-Admin
+ ~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,Test-Admin
```

This error occurs because the script needs elevated privileges to install software.

#### Overview of `install_software.ps1`

This script is named `install_software.ps1` and is designed to install a predefined list of software using Chocolatey. It checks for each software's existence on the system and installs it only if it's not already installed, ensuring idempotency.

#### Prompt for Confirmation

When you run the script, you may see a prompt asking for confirmation to proceed with the installation. You can respond with `Y` to continue or `N` to cancel the installation.
If you don't want to see these prompts, you can pass the `-y` flag to the script to automatically confirm all installations.

#### Example Output (with prompts)

```powershell
PS C:\Windows\system32> iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/TIBCOSoftware/ibi-webFOCUS-CE/work-in-progress/Scripts/bootstrap/windows/install_software.ps1'))
Chocolatey is already installed.
Installing all tools...
Do you want to install [slack]? (y/n/all/exit): y
Installing slack...
========================================
Installing slack...
Running command: choco install slack -y
slack installed successfully!
========================================
notepad++ is already installed.
Do you want to install [7zip]? (y/n/all/exit): all

```

#### Software Installed by This Script

The script installs the following software:

- **Slack:** A popular messaging app for teams, providing real-time messaging, file sharing, and integrations with other tools.
- **Notepad++:** A free source code editor and Notepad replacement that supports several languages.
- **KDiff3:** Is a graphical text difference analyzer for up to 3 input files, provides character-by-character analysis and a text merge tool with integrated editor. It can also compare and merge directories
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
- **Google Chrome:** A fast, secure, and widely-used web browser developed by Google.

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

#### Downloading and Running the Script Locally

1. **Download the Script:**
   - Navigate to the raw script URL in your browser:
     ```
     https://raw.githubusercontent.com/TIBCOSoftware/ibi-webFOCUS-CE/work-in-progress/Scripts/bootstrap/windows/install_software.ps1
     ```
   - Right-click on the page and select `Save As...` to download the script to your local machine.

2. **Edit the Script:**
   - Open the downloaded `install_software.ps1` file in a text editor like Notepad++ or Visual Studio Code.
   - Make any necessary changes to the script, such as adding or removing software installations.

3. **Run the Script Locally:**
   - Open PowerShell as Administrator.
   - Navigate to the directory where you saved the script using the `cd` command.
   - Execute the script by running:
     ```powershell
     ./install_software.ps1
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

### Sample output of the script

```plaintext
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.
                                                                                                                        Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows                                                                                                                                                       PS C:\Windows\system32> iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/TIBCOSoftware/ibi-webFOCUS-CE/work-in-progress/Scripts/bootstrap/windows/install_software.ps1'))                               Installing Chocolatey...                                                                                                Forcing web requests to allow TLS v1.2 (Required for requests to Chocolatey.org)
Getting latest version of the Chocolatey package for download.
Not using proxy.
Getting Chocolatey from https://community.chocolatey.org/api/v2/package/chocolatey/2.3.0.
Downloading https://community.chocolatey.org/api/v2/package/chocolatey/2.3.0 to C:\Users\pshah\AppData\Local\Temp\chocolatey\chocoInstall\chocolatey.zip
Not using proxy.
Extracting C:\Users\pshah\AppData\Local\Temp\chocolatey\chocoInstall\chocolatey.zip to C:\Users\pshah\AppData\Local\Temp\chocolatey\chocoInstall
Installing Chocolatey on the local machine
Creating ChocolateyInstall as an environment variable (targeting 'Machine')
  Setting ChocolateyInstall to 'C:\ProgramData\chocolatey'
WARNING: It's very likely you will need to close and reopen your shell
  before you can use choco.
Restricting write permissions to Administrators
We are setting up the Chocolatey package repository.
The packages themselves go to 'C:\ProgramData\chocolatey\lib'
  (i.e. C:\ProgramData\chocolatey\lib\yourPackageName).
A shim file for the command line goes to 'C:\ProgramData\chocolatey\bin'
  and points to an executable in 'C:\ProgramData\chocolatey\lib\yourPackageName'.

Creating Chocolatey CLI folders if they do not already exist.

chocolatey.nupkg file not installed in lib.
 Attempting to locate it from bootstrapper.
PATH environment variable does not have C:\ProgramData\chocolatey\bin in it. Adding...
WARNING: Not setting tab completion: Profile file does not exist at
'C:\Users\pshah\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'.
Chocolatey CLI (choco.exe) is now ready.
You can call choco from anywhere, command line or powershell by typing choco.
Run choco /? for a list of functions.
You may need to shut down and restart powershell and/or consoles
 first prior to using choco.
Ensuring Chocolatey commands are on the path
Ensuring chocolatey.nupkg is in the lib folder
Chocolatey installed successfully!
Installing all tools...
========================================
Installing slack...
Running command: choco install slack -y
slack installed successfully!
========================================
========================================
Installing notepad++...
Running command: choco install notepadplusplus -y
notepad++ installed successfully!
========================================
========================================
Installing 7zip...
Running command: choco install 7zip -y
7zip installed successfully!
========================================
========================================
Installing winscp...
Running command: choco install winscp -y
winscp installed successfully!
========================================
========================================
Installing MobaXterm...
Running command: choco install mobaxterm -y
MobaXterm installed successfully!
========================================
========================================
Installing sublimetext...
Running command: choco install sublimetext3 -y
sublimetext installed successfully!
========================================
========================================
Installing putty...
Running command: choco install putty -y
putty installed successfully!
========================================
========================================
Installing git...
Running command: choco install git -y
git installed successfully!
========================================
========================================
Installing python...
Running command: choco install python -y
python installed successfully!
========================================
========================================
Installing conda...
Running command: choco install miniconda3 -y
conda installed successfully!
========================================
========================================
Installing vscode...
Running command: choco install vscode -y
vscode installed successfully!
========================================
========================================
Installing jdk8...
Running command: choco install jdk8 -y
jdk8 installed successfully!
========================================
========================================
Installing docker...
Running command: choco install docker-desktop -y
docker installed successfully!
========================================
========================================
Installing adobereader...
Running command: choco install adobereader -y
adobereader installed successfully!
========================================
========================================
Installing zoom...
Running command: choco install zoom -y
zoom installed successfully!
========================================
========================================
Installing winrar...
Running command: choco install winrar -y
winrar installed successfully!
========================================
========================================
Installing openssh...
Running command: choco install openssh -y
openssh installed successfully!
========================================
========================================
Installing citrix-workspace...
Running command: choco install citrix-workspace -y
citrix-workspace installed successfully!
========================================

Installation Report:
=====================
Slack: Installed
notepad++: Installed
7zip: Installed
winscp: Installed
MobaXterm: Installed
sublimetext: Installed
putty: Installed
git: Installed
python: Installed
conda: Installed
vscode: Installed
jdk8: Installed
docker: Installed
adobereader: Installed
zoom: Installed
winrar: Installed
openssh: Installed
citrix-workspace: Installed
PS C:\Windows\system32>
PS C:\Windows\system32>
