param (
    [switch]$y
)

# Global variable to track if the user selected "Yes to all"
$global:yesToAll = $false

# Function to check if running as administrator
function Test-Admin {
    $isAdmin = [bool]([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if (-not $isAdmin) {
        Write-Error "Script must be run as Administrator!" -ErrorAction Stop
    }
}

# Function to install Chocolatey
function Install-Chocolatey {
    if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Host "Chocolatey installed successfully!"
    } else {
        Write-Host "Chocolatey is already installed."
    }
}

# Function to install a tool using Chocolatey
function Install-Tool {
    param (
        [string]$toolName,
        [string]$chocoName
    )

    if (-not (Get-Command $toolName -ErrorAction SilentlyContinue)) {
        if (-not $y -and -not $yesToAll) {
            # Correctly display the tool name in the prompt
            $response = Read-Host "Do you want to install [$toolName]? (y/n/all/exit)"
            switch ($response.ToLower()) {
                "y" { # Proceed with installation
                    Write-Host "Installing $toolName..."
                }
                "n" { # Skip installation
                    Write-Host "Skipping $toolName based on user choice."
                    return "skipped"
                }
                "all" { # Install all without further asking
                    Write-Host "Proceeding with 'Yes to all' for remaining installations."
                    $global:yesToAll = $true
                }
                "exit" { # Exit the script gracefully
                    Write-Host "Exiting the script as per user request."
                    exit
                }
                default { # Invalid input, prompt again
                    Write-Host "Invalid input. Please enter y, n, all, or exit."
                    return Install-Tool -toolName $toolName -chocoName $chocoName
                }
            }
        }

        Write-Host "========================================"
        Write-Host "Installing $toolName..."
        $installCommand = "choco install $chocoName -y"
        Write-Host "Running command: $installCommand"
        Invoke-Expression $installCommand
        Write-Host "$toolName installed successfully!"
        Write-Host "========================================"
        return "installed"
    } else {
        Write-Host "$toolName is already installed."
        return "already installed"
    }
}

# Define list of tools
$tools = @(
    @{ ToolName = "notepad++"; ChocoName = "notepadplusplus" }
    @{ ToolName = "KDiff"; ChocoName = "kdiff3" } #
    @{ ToolName = "7zip"; ChocoName = "7zip" }
    @{ ToolName = "winscp"; ChocoName = "winscp" }
    @{ ToolName = "MobaXterm"; ChocoName = "mobaxterm" }
    @{ ToolName = "sublimetext"; ChocoName = "sublimetext3" }
    @{ ToolName = "putty"; ChocoName = "putty" }
    @{ ToolName = "git"; ChocoName = "git" }
    @{ ToolName = "python"; ChocoName = "python" }
    @{ ToolName = "conda"; ChocoName = "miniconda3" }
    @{ ToolName = "vscode"; ChocoName = "vscode" }
    @{ ToolName = "jdk11"; ChocoName = "adoptopenjdk11" } # choco install adoptopenjdk11
    @{ ToolName = "docker"; ChocoName = "docker-desktop" }
    @{ ToolName = "adobereader"; ChocoName = "adobereader" }
    @{ ToolName = "zoom"; ChocoName = "zoom" }
    @{ ToolName = "winrar"; ChocoName = "winrar" }
    @{ ToolName = "openssh"; ChocoName = "openssh" }
    @{ ToolName = "citrix-workspace"; ChocoName = "citrix-workspace" }
    @{ ToolName = "Google Chrome"; ChocoName = "googlechrome" }
)

# Run the script
Test-Admin

Install-Chocolatey

$report = @()

Write-Host "Installing all tools..."
$report += if (Install-Tool -toolName "slack" -chocoName "slack") { "Slack: Installed" } else { "Slack: Already installed" }
foreach ($tool in $tools) {
    $status = Install-Tool -toolName $tool.ToolName -chocoName $tool.ChocoName
    if ($status -eq "skipped") {
        $report += "$($tool.ToolName): Skipped based on user choice"
    } elseif ($status -eq "installed") {
        $report += "$($tool.ToolName): Installed"
    } else {
        $report += "$($tool.ToolName): Already installed"
    }
}

# Print the report
Write-Host "`nInstallation Report:"
Write-Host "====================="
$report | ForEach-Object { Write-Host $_ }
