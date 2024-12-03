# AUTO UPDATER FOR EMULATORS

# Get the current directory
$currentDirectory = Get-Location

# Define the path of the new directory
$newDirectory = Join-Path -Path $currentDirectory -ChildPath "downloads"

# Check if the directory exists
if (-not (Test-Path -Path $newDirectory)) {
    # Create the new directory
    New-Item -ItemType Directory -Path $newDirectory | Out-Null
    Write-Output "The 'downloads' folder has been created in the current directory."
}

# Initialize stats
$EmulatorsUpdated = 0
$EmulatorsFailed = 0
$EmulatorsAlreadyLatest = 0

##############################################################################################

# RPCS3 update

cls
Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "1) RPCS3 - updating..." -ForegroundColor Red
Write-Host "2) DuckStation" -ForegroundColor Black
Write-Host "3) PCSX2" -ForegroundColor Black
Write-Host "4) PPSSPP" -ForegroundColor Black
Write-Host "5) RetroArch" -ForegroundColor Black
Write-Host "6) Citron" -ForegroundColor Black
Write-Host "7) XEMU" -ForegroundColor Black
Write-Host "8) Dolphin" -ForegroundColor Black

Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "##############################################################################################"
Write-Host "                                        Updating RPCS3"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = Join-Path (Get-Location) 'RPCS3'

# Get the latest release information from the GitHub API
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/RPCS3/rpcs3-binaries-win/releases/latest"

# Check if the response contains the necessary information
if ($response.assets) {
    # Extract the download URL and filename from the asset
    $downloadUrl = $response.assets[0].browser_download_url
    $filename = [System.IO.Path]::GetFileName($downloadUrl)

    # If the file already exists, remove it before downloading the updated version
    if (Test-Path downloads/$filename) {
        Write-Host "You Have Latest RPCS3 Version $filename"
        $RPCS3done = "`e[40mYou Already Have Latest $filename`e[0m"
        $EmulatorsAlreadyLatest += 1
    }
    else {
        Remove-Item downloads/rpcs3*win64.7z -Recurse -Force
        # Download the file using the extracted URL
        Invoke-WebRequest -Uri $downloadUrl -OutFile downloads/$filename
        7z x downloads/$filename -o"$targetFolder" -y
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Extraction successful."
            $RPCS3done = "Updated To $filename ✓"
            $EmulatorsUpdated += 1
        }
        else {
            Write-Host "Extraction failed."
            Remove-Item downloads/$filename -Recurse -Force
            $RPCS3done = "`e[31mextraction failed`e[0m"
            $EmulatorsFailed += 1
        }
    }
}
Write-Host "##############################################################################################"
Write-Host "                                        Updating RPCS3 Finished"
Write-Host "##############################################################################################"

# DuckStation update

cls
Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "1) RPCS3 - $RPCS3done" -ForegroundColor Green
Write-Host "2) DuckStation - updating..." -ForegroundColor Red
Write-Host "3) PCSX2" -ForegroundColor Black
Write-Host "4) PPSSPP" -ForegroundColor Black
Write-Host "5) RetroArch" -ForegroundColor Black
Write-Host "6) Citron" -ForegroundColor Black
Write-Host "7) XEMU" -ForegroundColor Black
Write-Host "8) Dolphin" -ForegroundColor Black

Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "##############################################################################################"
Write-Host "                                        Updating DuckStation"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = Join-Path (Get-Location) 'DuckStation'
# Define the URL for the API request
$url = "https://api.github.com/repos/stenzek/duckstation/releases/latest"
# Send the API request and store the response
$response = Invoke-RestMethod -Uri $url -Headers $headers
$date = Get-Date $response.created_at -Format "dd/MM/yyyy"
$filename = "duckstation-windows-x64-release-$date.zip"

if (Test-Path downloads/$filename) {
    Write-Host "You Have Latest DuckStation Version $filename"
    $DuckStationdone = "`e[40mYou Already Have Latest $filename`e[0m"
    $EmulatorsAlreadyLatest += 1
}
else {
    Remove-Item downloads/duckstation-windows-x64-release*.zip -Recurse -Force
    # Download the file using the extracted URL
    Invoke-WebRequest -Uri https://github.com/stenzek/duckstation/releases/download/latest/duckstation-windows-x64-release.zip -OutFile downloads/$filename
    7z x downloads/$filename -o"$targetFolder" -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Extraction successful."
        $DuckStationdone = "Updated To $filename ✓"
        $EmulatorsUpdated += 1
    }
    else {
        Write-Host "Extraction failed."
        Remove-Item downloads/$filename -Recurse -Force
        $DuckStationdone = "`e[31mextraction failed`e[0m"
        $EmulatorsFailed += 1
    }
}
Write-Host "##############################################################################################"
Write-Host "                                        Updating DuckStation Finished"
Write-Host "##############################################################################################"

# PCSX2 update

cls
Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "1) RPCS3 - $RPCS3done" -ForegroundColor Green
Write-Host "2) DuckStation - $DuckStationdone" -ForegroundColor Green
Write-Host "3) PCSX2 - updating..." -ForegroundColor Red
Write-Host "4) PPSSPP" -ForegroundColor Black
Write-Host "5) RetroArch" -ForegroundColor Black
Write-Host "6) Citron" -ForegroundColor Black
Write-Host "7) XEMU" -ForegroundColor Black
Write-Host "8) Dolphin" -ForegroundColor Black

Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "##############################################################################################"
Write-Host "                                        Updating PCSX2"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = Join-Path (Get-Location) 'PCSX2'

# Get the latest release information from the GitHub API
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/PCSX2/pcsx2/releases"

# Check if the response contains the necessary information
$latestRelease = $response[0]
# Check if the response contains the necessary information
if ($latestRelease.assets) {
    $windowsAsset = $response.assets | Where-Object { $_.name -like '*windows*' -and $_.name -like '*Qt.7z' }

    if ($windowsAsset) {
        # Extract the download URL and filename from the asset
        $downloadUrl = $windowsAsset.browser_download_url[0]
        $filename = [System.IO.Path]::GetFileName($downloadUrl)
        # If the file already exists, remove it before downloading the updated version
        if (Test-Path downloads/$filename) {
            Write-Host "You Have Latest PCSX2 Version $filename"
            $PCSX2done = "`e[40mYou Already Have Latest $filename`e[0m"
            $EmulatorsAlreadyLatest += 1
        }
        else {
            Remove-Item downloads/pcsx2*windows-x64-Qt.7z -Recurse -Force
            # Download the file using the extracted URL
            Invoke-WebRequest -Uri $downloadUrl -OutFile downloads/$filename
            7z x downloads/$filename -o"$targetFolder" -y
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Extraction successful."
                $PCSX2done = "Updated To $filename ✓"
                $EmulatorsUpdated += 1
            }
            else {
                Write-Host "Extraction failed."
                Remove-Item downloads/$filename -Recurse -Force
                $PCSX2done = "`e[31mextraction failed`e[0m"
                $EmulatorsFailed += 1
            }
        }
    }
}

Write-Host "##############################################################################################"
Write-Host "                                        Updating PCSX2 Finished"
Write-Host "##############################################################################################"

# PPSSPP update

cls
Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "1) RPCS3 - $RPCS3done" -ForegroundColor Green
Write-Host "2) DuckStation - $DuckStationdone" -ForegroundColor Green
Write-Host "3) PCSX2 - $PCSX2done" -ForegroundColor Green
Write-Host "4) PPSSPP - updating..." -ForegroundColor Red
Write-Host "5) RetroArch" -ForegroundColor Black
Write-Host "6) Citron" -ForegroundColor Black
Write-Host "7) XEMU" -ForegroundColor Black
Write-Host "8) Dolphin" -ForegroundColor Black

Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "##############################################################################################"
Write-Host "                                        Updating PPSSPP"
Write-Host "##############################################################################################"
# Specify the target folder
$targetFolder = Join-Path (Get-Location) 'PPSSPP'

# Get the latest release information from the GitHub API
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/hrydgard/ppsspp/releases/latest"
$version = $response.tag_name -replace '^v', '' -replace '\.', '_'

# Extract the download URL and filename from the asset
$downloadUrl = "https://www.ppsspp.org/files/$version/ppsspp_win.zip"
$filename = "ppsspp_win_$version.zip"

if (Test-Path downloads/$filename) {
    Write-Host "You Have Latest PPSSPP Version $filename"
    $PPSSPPdone = "`e[40mYou Already Have Latest $filename`e[0m"
    $EmulatorsAlreadyLatest += 1
}
else {
    Remove-Item downloads/ppsspp_win_*.zip -Recurse -Force
    Invoke-WebRequest -Uri "$downloadUrl" -OutFile downloads/"$filename" -AllowInsecureRedirect

    7z x downloads/$filename -o"temp" -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Extraction successful."
        Copy-Item  -Path "temp/*" -Destination $targetFolder -Recurse -force
        Remove-Item temp -Recurse -Force
        $PPSSPPdone = "Updated To $filename ✓"
        $EmulatorsUpdated += 1
    }
    else {
        Write-Host "Extraction failed."
        Remove-Item downloads/$filename -Recurse -Force
        $PPSSPPdone = "`e[31mextraction failed`e[0m"
        $EmulatorsFailed += 1
    }
}
Write-Host "##############################################################################################"
Write-Host "                                        Updating PPSSPP Finished"
Write-Host "##############################################################################################"

# RetroArch update

cls
Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "1) RPCS3 - $RPCS3done" -ForegroundColor Green
Write-Host "2) DuckStation - $DuckStationdone" -ForegroundColor Green
Write-Host "3) PCSX2 - $PCSX2done" -ForegroundColor Green
Write-Host "4) PPSSPP - $PPSSPPdone" -ForegroundColor Green
Write-Host "5) RetroArch - updating..." -ForegroundColor Red
Write-Host "6) Citron" -ForegroundColor Black
Write-Host "7) XEMU" -ForegroundColor Black
Write-Host "8) Dolphin" -ForegroundColor Black

Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "##############################################################################################"
Write-Host "                                        Updating RetroArch"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = Join-Path (Get-Location) 'RetroArch'
# Send a GET request to the URL
$response = Invoke-RestMethod -Uri "https://buildbot.libretro.com/nightly/windows/x86_64/"
# Convert the response to a string
$responseString = $response.ToString()
# Define the pattern to match the RetroArch.7z file and its last modified date
$pattern = 'href="/nightly/windows/x86_64/RetroArch.7z">RetroArch.7z</a></td><td class="fb-d">(\d{4}-\d{2}-\d{2}) \d{2}:\d{2}</td>'
# Use regex to find the match
if ($responseString -match $pattern) {
    $lastModifiedDate = $Matches[1]
}
$filename = "RetroArch-$lastModifiedDate.7z"
if (Test-Path downloads/$filename) {
    Write-Host "You Have Latest RetroArch Version $filename"
    $RetroArchdone = "`e[40mYou Already Have Latest $filename`e[0m"
    $EmulatorsAlreadyLatest += 1
}
else {
    Remove-Item downloads/RetroArch*.7z -Recurse -Force
    $downloadUrl = "https://buildbot.libretro.com/nightly/windows/x86_64/RetroArch.7z"
    Invoke-WebRequest -Uri "$downloadUrl" -OutFile "downloads/$filename"
    7z x downloads/$filename -o"$targetFolder" -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Extraction successful."
        $RetroArchdone = "Updated To $filename ✓"
        $EmulatorsUpdated += 1
    }
    else {
        Write-Host "Extraction failed."
        Remove-Item downloads/$filename -Recurse -Force
        $RetroArchdone = "`e[31mextraction failed`e[0m"
        $EmulatorsFailed += 1
    }
}
Write-Host "##############################################################################################"
Write-Host "                                        Updating RetroArch Finished"
Write-Host "##############################################################################################"

# Citron update

cls
Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "1) RPCS3 - $RPCS3done" -ForegroundColor Green
Write-Host "2) DuckStation - $DuckStationdone" -ForegroundColor Green
Write-Host "3) PCSX2 - $PCSX2done" -ForegroundColor Green
Write-Host "4) PPSSPP - $PPSSPPdone" -ForegroundColor Green
Write-Host "5) RetroArch - $RetroArchdone" -ForegroundColor Green
Write-Host "6) Citron - updating..." -ForegroundColor Red
Write-Host "7) XEMU" -ForegroundColor Black
Write-Host "8) Dolphin" -ForegroundColor Black

Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "##############################################################################################"
Write-Host "                                        Updating Citron"
Write-Host "##############################################################################################"
# Specify the target folder
$targetFolder = Join-Path (Get-Location) 'Citron'

# Define the RSS feed URL
$rssUrl = "https://git.citron-emu.org/Citron/Citron/releases.rss"

# Download and parse the RSS feed
$rssContent = Invoke-WebRequest -Uri $rssUrl -UseBasicParsing
[xml]$rssXml = $rssContent.Content

# Extract the latest release title
$latestTitle = $rssXml.rss.channel.item[0].title

# Extract the version name using regex
if ($latestTitle -match "Nightly Build (\d{8}_\d{6})") {
    $latestVersion = $matches[1]
}
else {
    Write-Output "No valid version found in the latest release title."
}

# Extract the download URL and filename from the asset
$downloadUrl = "https://git.citron-emu.org/Citron/Citron/releases/download/nightly-$latestVersion/Citron-Windows_x86_64.zip"
$filename = "Citron-Windows-$latestVersion.zip"


if (Test-Path downloads/$filename) {
    Write-Host "You Have Latest Citron Version $filename"
    $Citrondone = "`e[40mYou Already Have Latest $filename`e[0m"
    $EmulatorsAlreadyLatest += 1
}
else {
    Remove-Item downloads/Citron-Windows-*.zip -Recurse -Force
    # Download the file using the extracted URL
    Invoke-WebRequest -Uri $downloadUrl -OutFile downloads/$filename
    7z x downloads/$filename -o"temp" -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Extraction successful."
        Copy-Item  -Path "temp/Citron-Windows_x86_64/*" -Destination $targetFolder -Recurse -force
        Remove-Item temp -Recurse -Force
        $Citrondone = "Updated To $filename ✓"
        $EmulatorsUpdated += 1
    }
    else {
        Write-Host "Extraction failed."
        Remove-Item downloads/$filename -Recurse -Force
        $Citrondone = "`e[31mextraction failed`e[0m"
        $EmulatorsFailed += 1
    }
}
Write-Host "##############################################################################################"
Write-Host "                                        Updating Citron Finished"
Write-Host "##############################################################################################"

# XEMU update

cls
Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "1) RPCS3 - $RPCS3done" -ForegroundColor Green
Write-Host "2) DuckStation - $DuckStationdone" -ForegroundColor Green
Write-Host "3) PCSX2 - $PCSX2done" -ForegroundColor Green
Write-Host "4) PPSSPP - $PPSSPPdone" -ForegroundColor Green
Write-Host "5) RetroArch - $RetroArchdone" -ForegroundColor Green
Write-Host "6) Citron - $Citrondone" -ForegroundColor Green
Write-Host "7) XEMU - updating..." -ForegroundColor red
Write-Host "8) Dolphin" -ForegroundColor Black

Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "##############################################################################################"
Write-Host "                                        Updating XEMU"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = Join-Path (Get-Location) 'XEMU'

# Get the latest release information from the GitHub API
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/xemu-project/xemu/releases/latest"
$version = $response.tag_name
# Check if the response contains the necessary information
# Extract the download URL and filename from the asset
$downloadUrl = "https://github.com/xemu-project/xemu/releases/download/$version/xemu-win-release.zip"
$filename = "xemu-win-release-$version.zip"
# If the file already exists, remove it before downloading the updated version
if (Test-Path downloads/$filename) {
    Write-Host "You Have Latest XEMU Version $filename"
    $XEMUdone = "`e[40mYou Already Have Latest $filename`e[0m"
    $EmulatorsAlreadyLatest += 1
}
else {
    Remove-Item downloads/xemu-win-release*.zip -Recurse -Force
    # Download the file using the extracted URL
    Invoke-WebRequest -Uri $downloadUrl -OutFile downloads/$filename
    7z x downloads/$filename -o"$targetFolder" -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Extraction successful."
        $XEMUdone = "Updated To $filename ✓"
        $EmulatorsUpdated += 1
    }
    else {
        Write-Host "Extraction failed."
        Remove-Item downloads/$filename -Recurse -Force
        $XEMUdone = "`e[31mextraction failed`e[0m"
        $EmulatorsFailed += 1
    }
}

Write-Host "##############################################################################################"
Write-Host "                                        Updating XEMU Finished"
Write-Host "##############################################################################################"

# Dolphin update

cls
Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "1) RPCS3 - $RPCS3done" -ForegroundColor Green
Write-Host "2) DuckStation - $DuckStationdone" -ForegroundColor Green
Write-Host "3) PCSX2 - $PCSX2done" -ForegroundColor Green
Write-Host "4) PPSSPP - $PPSSPPdone" -ForegroundColor Green
Write-Host "5) RetroArch - $RetroArchdone" -ForegroundColor Green
Write-Host "6) Citron - $Citrondone" -ForegroundColor Green
Write-Host "7) XEMU - $XEMUdone" -ForegroundColor Green
Write-Host "8) Dolphin - updating..." -ForegroundColor Red

Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "##############################################################################################"
Write-Host "                                        Updating Dolphin"
Write-Host "##############################################################################################"

# Specify the target folder
$targetFolder = Join-Path (Get-Location) 'Dolphin'

# Download the webpage content
$page = Invoke-WebRequest -Uri "https://dolphin-emu.org/download/"

# Convert the Content to a string
$content = $page.Content

# Find the index of the div with id "download-dev"
$index = $content.IndexOf('id="download-dev"')

# If the div was found
if ($index -ne -1) {
    # Extract the part of the content after the div
    $contentAfterDiv = $content.Substring($index)

    # Find the index of the first download link for Windows x64
    $linkIndex = $contentAfterDiv.IndexOf('<a href="https://dl.dolphin-emu.org/builds/')

    # If the link was found
    if ($linkIndex -ne -1) {
        # Extract the part of the content after the link
        $contentAfterLink = $contentAfterDiv.Substring($linkIndex)

        # Find the end of the link
        $endIndex = $contentAfterLink.IndexOf('" class="btn always-ltr btn-info win"><i class="icon-download-alt"></i> Windows x64</a>')

        # If the end of the link was found
        if ($endIndex -ne -1) {
            # Extract the link
            $link = $contentAfterLink.Substring(0, $endIndex)
            $downloadLink = $link.Replace('<a href="', '')
        }
    }
}
# Output the version number
$filename = [System.IO.Path]::GetFileName($downloadLink)
if (Test-Path downloads/$filename) {
    Write-Host "You Have Latest Dolphin Version $filename"
    $Dolphindone = "`e[40mYou Already Have Latest $filename`e[0m"
    $EmulatorsAlreadyLatest += 1
}
else {
    Remove-Item downloads/dolphin-master*x64.7z -Recurse -Force
    # Download the file using the extracted URL
    Invoke-WebRequest -Uri "$downloadLink" -OutFile downloads/$filename
    7z x downloads/$filename -o"temp" -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Extraction successful."
        Copy-Item  -Path "temp/Dolphin-x64/*" -Destination $targetFolder -Recurse -force
        Remove-Item temp -Recurse -Force
        $Dolphindone = "Updated To $filename ✓"
        $EmulatorsUpdated += 1
    }
    else {
        Write-Host "Extraction failed."
        Remove-Item downloads/$filename -Recurse -Force
        $Dolphindone = "`e[31mextraction failed`e[0m"
        $EmulatorsFailed += 1
    }
}
Write-Host "##############################################################################################"
Write-Host "                                        Updating Dolphin Finished"
Write-Host "##############################################################################################"

cls
Write-Host "##############################################################################################" -ForegroundColor Blue

Write-Host "1) RPCS3 - $RPCS3done" -ForegroundColor Green
Write-Host "2) DuckStation - $DuckStationdone" -ForegroundColor Green
Write-Host "3) PCSX2 - $PCSX2done" -ForegroundColor Green
Write-Host "4) PPSSPP - $PPSSPPdone" -ForegroundColor Green
Write-Host "5) RetroArch - $RetroArchdone" -ForegroundColor Green
Write-Host "6) Citron - $Citrondone" -ForegroundColor Green
Write-Host "7) XEMU - $XEMUdone" -ForegroundColor Green
Write-Host "8) Dolphin - $Dolphindone" -ForegroundColor Green
Write-Host ""
# Display the stats
Write-Host "Emulators Updated             : " -NoNewline
Write-Host "[ $EmulatorsUpdated ]" -ForegroundColor Green

Write-Host "Emulators Update Failed       : " -NoNewline
Write-Host "[ $EmulatorsFailed ]" -ForegroundColor Red

Write-Host "Emulators Already Latest      : " -NoNewline
Write-Host "[ $EmulatorsAlreadyLatest ]" -ForegroundColor Yellow

Write-Host "##############################################################################################" -ForegroundColor Blue
