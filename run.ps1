# Audio switcher for Windows devices by DCRM 
# v 1.0

$PathRun = $PSCommandPath | Split-Path -Parent

Write-Host "Current location [$PathRun]"
Set-Location -Path $PathRun

# Function to display available playback devices
function Show-PlaybackDevices {
    param (
        [array]$DeviceList
    )

    Write-Host "Available playback devices:"
    $DeviceList | ForEach-Object {
        Write-Host "$($_.Id) - $($_.Name)"
    }
}

# Check for the AudioDeviceCmdlets module
if (-not (Get-Module -ListAvailable -Name AudioDeviceCmdlets)) {
    Write-Host "AudioDeviceCmdlets module not found. Installing..."

    # Set download URL
    $moduleUrl = "https://github.com/frgnca/AudioDeviceCmdlets/releases/download/v3.1/AudioDeviceCmdlets.dll"
    $modulePath = "$(Get-Location)\AudioDeviceCmdlets.dll"

    # Check if file already exists
    if (Test-Path $modulePath) {
        Write-Host "AudioDeviceCmdlets module exists."
    }
    else {
        # Download the module
        Invoke-WebRequest -Uri $moduleUrl -OutFile $modulePath
        Write-Host "AudioDeviceCmdlets module downloaded successfully."
    }
}

Clear-Host

# Import the module
Import-Module "$(Get-Location)\AudioDeviceCmdlets.dll" -ErrorAction Stop

# Get the list of playback devices
$devices = Get-AudioDevice -List

if (-not $devices -or $devices.Count -eq 0) {
    Write-Host "No playback devices found."
    exit 1
}

# Check arguments
if ($args.Count -eq 0) {
    Show-PlaybackDevices -DeviceList $devices
    exit 0
}

$TargetDevice = $args[0]

# Check if the specified device ID exists
$targetDevice = $devices | Where-Object { $_.Id -eq $TargetDevice -or $_.Name -eq $TargetDevice }
if (-not $targetDevice) {
    Write-Host "Device with ID or name '$TargetDevice' not found in the list of available devices."
    Show-PlaybackDevices -DeviceList $devices
    Pause
    exit 1
}

# Set communication mode
$AdditionalParam = if ($args.Count -gt 1) { $args[1] } else { "" }

Write-Host "Active device switched to: $($targetDevice.Name) $AdditionalParam"
# Set the specified device
switch ($AdditionalParam) {
    default {
        Set-AudioDevice -Id $targetDevice.Id
    }
    "-DefaultOnly" {
        Set-AudioDevice -Id $targetDevice.Id -DefaultOnly
    }
    "-CommunicationOnly" {
        Set-AudioDevice -Id $targetDevice.Id -CommunicationOnly
    }
}