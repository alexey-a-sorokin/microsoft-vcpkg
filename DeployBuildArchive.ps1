[CmdletBinding()]
param(
    [string]$tfsBranch,
    [Parameter(ParameterSetName='SetLatest')]
    [switch]$latest,
    [Parameter(ParameterSetName='SetBuildNumber')]
    [string]$buildNumber
)

$scriptsDir = split-path -parent $script:MyInvocation.MyCommand.Definition
. "$scriptsDir\VcpkgPowershellUtils.ps1"
. "$scriptsDir\VcpkgPowershellUtils-Private.ps1"

$buildArchiveFolderRoot = "\\vcpkg-000\General\CustomBuilds"
if ($latest)
{
    $branchBuildArchives = Get-ChildItem $buildArchiveFolderRoot | Where-Object {$_.Name -match "^$tfsBranch.+\.7z"}
    if ($branchBuildArchives.count -eq 0)
    {
        Write-Error "Count not find build archives for branch $tfsBranch in: $buildArchiveFolderRoot"
        throw;
    }

    $buildArchive = ($branchBuildArchives | Sort-object Name -Descending).fullname[0]
}
else
{
    $buildArchive = "$buildArchiveFolderRoot\$tfsBranch-$buildNumber.7z"
}

if (!(Test-Path $buildArchive))
{
    Write-Error "$buildArchive was not found"
    throw;
}

Write-Host "Deploying $buildArchive"

$deploymentRoot = "C:\VS2017\Unstable\VC\Tools\MSVC\"
$msvcVersion = @(dir -Directory $deploymentRoot | Sort-object Name -Descending)[0].Name
$deploymentPath = "$deploymentRoot\$msvcVersion"

Write-Host "Cleaning-up $deploymentRoot..."
Get-Process -Name "cl" -ErrorAction SilentlyContinue | Stop-Process
Get-Process -Name "VCTip" -ErrorAction SilentlyContinue | Stop-Process

# Debugging
findProcessesLockingFile "C:\VS2017\Unstable\VC\Tools\MSVC\14.12.25827\bin\HostX86\x86\msobj140.dll"

vcpkgCreateDirectoryIfNotExists $deploymentPath
Get-ChildItem $deploymentRoot -exclude $msvcVersion | % { vcpkgRemoveItem $_ }
Get-ChildItem $deploymentPath -exclude "crt" | % { vcpkgRemoveItem $_ }
Write-Host "Cleaning-up $deploymentRoot... done."

Write-Host "Copying $buildArchive..."
$buildArchiveName = Split-Path $buildArchive -leaf
$tempBuildArchive = "$deploymentRoot\$buildArchiveName"
Copy-Item $buildArchive -Destination $tempBuildArchive
Write-Host "Copying $buildArchive... done."

Write-Host "Deployment path: $deploymentPath"
Write-Host "Extracting 7z..."
$time7z = Measure-Command {& $scriptsDir\7za.exe x $tempBuildArchive -o"$deploymentPath" -y}
$formattedTime7z = vcpkgFormatElapsedTime $time7z
Write-Host "Extracting 7z... done. Time Taken: $formattedTime7z seconds"

