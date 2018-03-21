[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$vsInstallNickname,
    [Parameter(Mandatory=$true)][ValidateSet('tfs','msvc', 'NOT_APPLICABLE')][string]$repo,
    [Parameter(Mandatory=$true)][string]$branch,
    [Parameter(Mandatory=$true)][ValidateSet('ret','chk', 'NOT_APPLICABLE')][string]$retOrChk,
    [Parameter(Mandatory=$true)][string]$triplet,
    [Parameter(Mandatory=$true)][bool]$incremental,
    [Parameter(Mandatory=$false)][bool]$AlwaysLocal
)

Set-StrictMode -Version Latest

$vsInstallNickname = $vsInstallNickname.ToLower()
$branch = $branch.ToLower()
$triplet = $triplet.ToLower()

$scriptsDir = split-path -parent $script:MyInvocation.MyCommand.Definition
. "$scriptsDir\VcpkgPowershellUtils.ps1"
. "$scriptsDir\VcpkgPowershellUtils-Private.ps1"

$vcpkgRootDir = vcpkgFindFileRecursivelyUp $scriptsDir .vcpkg-root

# Re-exclude "C:\" from Windows Defender because it looks like the exclusion list is cleared on Windows Update
Add-MpPreference -ExclusionPath "C:\"

# Update the relevant Visual Studio installation - DISABLED due to flakiness
$vsInstallPath = findVSInstallPathFromNickname($vsInstallNickname)
# UnattendedVSupdate -installPath $vsInstallPath

$comment = "stable"
# For unstable builds, deploy the custom build archive
if ($vsInstallNickname -eq $VISUAL_STUDIO_2017_UNSTABLE_NICKNAME -and ![string]::IsNullOrEmpty($branch))
{
    $buildArchive = & $scriptsDir\GetLatestBuildArchive.ps1 -repo $repo -branch $branch -retOrChk $retOrChk
    & $scriptsDir\DeployBuildArchive.ps1 -buildArchive $buildArchive
    $comment = "$buildArchive"
}

# Create triplets
CreateTripletsForVS -vsInstallPath $vsInstallPath -vsInstallNickname $vsInstallNickname -outputDir "$vcpkgRootDir\triplets" -comment $comment

# Prepare installed dir
& $scriptsDir\PrepareInstalledDir.ps1 -triplet $triplet -incremental $incremental -AlwaysLocal $AlwaysLocal
