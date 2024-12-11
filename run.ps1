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
    } else {
        # Download the module
        Invoke-WebRequest -Uri $moduleUrl -OutFile $modulePath
        Write-Host "AudioDeviceCmdlets module downloaded successfully."
    }
}

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

$TargetDeviceId = $args[0]

# Check if the specified device ID exists
$targetDevice = $devices | Where-Object { $_.Id -eq $TargetDeviceId }
if (-not $targetDevice) {
    Write-Host "Device with ID '$TargetDeviceId' not found in the list of available devices."
    Show-PlaybackDevices -DeviceList $devices
    exit 1
}

# Set the specified device
Set-AudioDevice -ID $targetDevice.Id -DefaultOnly
Write-Host "Active device switched to: $($targetDevice.Name)"