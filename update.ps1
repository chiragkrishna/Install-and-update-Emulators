# AUTO UPDATER FOR EMULATORS

##############################################################################################

# yuzu update

Write-Host "##############################################################################################"
Write-Host "                                        Updating YUZU"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = 'D:\Retro Gaming\Emulators\yuzu'

# Get the latest release information from the GitHub API
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/yuzu-emu/yuzu-mainline/releases/latest"

# Check if the response contains the necessary information
if ($response.assets) {
    # Filter assets for the one with the desired name pattern (e.g., contains "windows" and ".7z")
    $windowsAsset = $response.assets | Where-Object { $_.name -like '*windows*' -and $_.name -like '*.7z' }

    if ($windowsAsset) {
        # Extract the download URL and filename from the asset
        $downloadUrl = $windowsAsset.browser_download_url
        $filename = [System.IO.Path]::GetFileName($downloadUrl)

        # If the file already exists, remove it before downloading the updated version
        if (Test-Path $filename) {
            Remove-Item $filename -Force
        }

        # Download the file using the extracted URL
        Invoke-WebRequest -Uri $downloadUrl -OutFile $filename
        7z x $filename -o"temp" -y
        Copy-Item  -Path "temp/yuzu-windows-msvc/*" -Destination $targetFolder -Recurse -force
        Remove-Item $filename -Recurse -Force
        Remove-Item temp -Recurse -Force
        Remove-Item yuzu/yuzu-windows-msvc-source-*.tar.xz -Recurse -Force
    } 
} else {
    Write-Host "Failed to retrieve YUZU download URL from the GitHub API."
}

Write-Host "##############################################################################################"
Write-Host "                                        Updating YUZU Finished"
Write-Host "##############################################################################################"


# RPCS3 update

Write-Host "##############################################################################################"
Write-Host "                                        Updating RPCS3"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = 'D:\Retro Gaming\Emulators\ps3'

# Get the latest release information from the GitHub API
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/RPCS3/rpcs3-binaries-win/releases/latest"

# Check if the response contains the necessary information
if ($response.assets) {
        # Extract the download URL and filename from the asset
        $downloadUrl = $response.assets[0].browser_download_url
        $filename = [System.IO.Path]::GetFileName($downloadUrl)

        # If the file already exists, remove it before downloading the updated version
        if (Test-Path $filename) {
            Remove-Item $filename -Force
        }

        # Download the file using the extracted URL
        Invoke-WebRequest -Uri $downloadUrl -OutFile $filename
        7z x $filename -o"$targetFolder" -y
        Remove-Item $filename -Recurse -Force
} else {
    Write-Host "Failed to retrieve RPCS3 download URL from the GitHub API."
}

Write-Host "##############################################################################################"
Write-Host "                                        Updating RPCS3 Finished"
Write-Host "##############################################################################################"

# DuckStation update

Write-Host "##############################################################################################"
Write-Host "                                        Updating DuckStation"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = 'D:\Retro Gaming\Emulators\ps1'

# Download the file using the extracted URL
Invoke-WebRequest -Uri https://github.com/stenzek/duckstation/releases/download/latest/duckstation-windows-x64-release.zip -OutFile duckstation-windows-x64-release.zip
7z x duckstation-windows-x64-release.zip -o"$targetFolder" -y
Remove-Item duckstation-windows-x64-release.zip -Recurse -Force

Write-Host "##############################################################################################"
Write-Host "                                        Updating DuckStation Finished"
Write-Host "##############################################################################################"

# PS2 update

Write-Host "##############################################################################################"
Write-Host "                                        Updating PS2"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = 'D:\Retro Gaming\Emulators\ps2'

# Get the latest release information from the GitHub API
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/PCSX2/pcsx2/releases"

# Check if the response contains the necessary information
$latestRelease = $response[0]
$assetUrl = $latestRelease.assets[4].browser_download_url

    if ($latestRelease) {
        # Extract the download URL and filename from the asset
        $filename = [System.IO.Path]::GetFileName($assetUrl)

        # If the file already exists, remove it before downloading the updated version
        if (Test-Path $filename) {
            Remove-Item $filename -Force
        }

        # Download the file using the extracted URL
        Invoke-WebRequest -Uri $assetUrl -OutFile $filename
        7z x $filename -o"$targetFolder" -y
        Remove-Item $filename -Recurse -Force
} else {
    Write-Host "Failed to retrieve PS2 download URL from the GitHub API."
}


Write-Host "##############################################################################################"
Write-Host "                                        Updating PS2 Finished"
Write-Host "##############################################################################################"

# PPSSPP update

Write-Host "##############################################################################################"
Write-Host "                                        Updating PPSSPP"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = 'D:\Retro Gaming\Emulators\psp'

# get version number from site
$site = Invoke-WebRequest -Uri "https://buildbot.orphis.net/ppsspp/index.php"
$latest = $site.Links | Where-Object {$_.href -like "*Windows*"} | Select-Object -First 1
$version = $latest.href -replace ".*rev=(v\\d+(\\.\\d+){1,3}).*", "`$1"
$url = "$version"

# Define the regular expression pattern
$pattern = "rev=(.*?)&"

# Use Select-String to find matches in the URL
$matches = $url | Select-String -Pattern $pattern | ForEach-Object { $_.Matches.Groups[1].Value }

# Download the file using the extracted URL
$downloadUrl = "https://buildbot.orphis.net/ppsspp/index.php?m=dl&rev=$matches&platform=windows-amd64"
$filename = "ppsspp-$matches-windows-amd64.7z"
Invoke-WebRequest -Uri "$downloadUrl" -OutFile "$filename" -Headers @{
    "Referer"="https://buildbot.orphis.net";
    "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"
}
7z x $filename -o"temp" -y
        Copy-Item  -Path "temp/ppsspp/*" -Destination $targetFolder -Recurse -force
        Remove-Item $filename -Recurse -Force
        Remove-Item temp -Recurse -Force

Write-Host "##############################################################################################"
Write-Host "                                        Updating PPSSPP Finished"
Write-Host "##############################################################################################"

# RetroArch update

Write-Host "##############################################################################################"
Write-Host "                                        Updating RetroArch"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = 'D:\Retro Gaming\Emulators\RetroArch'
$downloadUrl = "https://buildbot.libretro.com/nightly/windows/x86_64/RetroArch.7z"
Invoke-WebRequest -Uri "$downloadUrl" -OutFile "RetroArch.7z"
7z x RetroArch.7z -o"$targetFolder" -y
Remove-Item RetroArch.7z -Recurse -Force

Write-Host "##############################################################################################"
Write-Host "                                        Updating RetroArch Finished"
Write-Host "##############################################################################################"

# Ryujinx update

Write-Host "##############################################################################################"
Write-Host "                                        Updating Ryujinx"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = 'D:\Retro Gaming\Emulators\Ryujinx\'

# Get the latest release information from the GitHub API
$releasesInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/Ryujinx/release-channel-master/releases"

# Get the first release (assumes releases are sorted by date, modify as needed)
$latestRelease = $releasesInfo[0]

# Get the first asset URL from the latest release
$assetUrl = $latestRelease.assets[7].browser_download_url
$filename = [System.IO.Path]::GetFileName($assetUrl)
# Download the file using the extracted URL
Invoke-WebRequest -Uri $assetUrl -OutFile $filename
7z x $filename -o"temp" -y
Copy-Item  -Path "temp/publish/*" -Destination $targetFolder -Recurse -force
Remove-Item $filename -Recurse -Force
Remove-Item temp -Recurse -Force

Write-Host "##############################################################################################"
Write-Host "                                        Updating Ryujinx Finished"
Write-Host "##############################################################################################"

# XEMU update

Write-Host "##############################################################################################"
Write-Host "                                        Updating XEMU"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = 'D:\Retro Gaming\Emulators\XBOX'

# Get the latest release information from the GitHub API
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/xemu-project/xemu/releases/latest"

# Check if the response contains the necessary information
if ($response.assets) {
        # Extract the download URL and filename from the asset
        $downloadUrl = $response.assets[8].browser_download_url
        $filename = [System.IO.Path]::GetFileName($downloadUrl)

        # If the file already exists, remove it before downloading the updated version
        if (Test-Path $filename) {
            Remove-Item $filename -Force
        }

        # Download the file using the extracted URL
        Invoke-WebRequest -Uri $downloadUrl -OutFile $filename
        7z x $filename -o"$targetFolder" -y
        Remove-Item $filename -Recurse -Force
} else {
    Write-Host "Failed to retrieve XEMU download URL from the GitHub API."
}

Write-Host "##############################################################################################"
Write-Host "                                        Updating XEMU Finished"
Write-Host "##############################################################################################"

# Dolphin update

Write-Host "##############################################################################################"
Write-Host "                                        Updating Dolphin"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = 'D:\Retro Gaming\Emulators\Dolphin'

# Send a web request to the URL
$request = Invoke-WebRequest -Uri "https://dolphin-emu.org/download/"

# Extract the download link from the response
$downloadLink = $request.Links | Where-Object href -like '*21*x64.7z' | Select-Object -First 1 | Select-Object -ExpandProperty href

# Output the version number
$filename = [System.IO.Path]::GetFileName($downloadLink)

# Download the file using the extracted URL
Invoke-WebRequest -Uri "$downloadLink" -OutFile $filename
7z x $filename -o"temp" -y
Copy-Item  -Path "temp/Dolphin-x64/*" -Destination $targetFolder -Recurse -force
Remove-Item $filename -Recurse -Force
Remove-Item temp -Recurse -Force

Write-Host "##############################################################################################"
Write-Host "                                        Updating Dolphin Finished"
Write-Host "##############################################################################################"
