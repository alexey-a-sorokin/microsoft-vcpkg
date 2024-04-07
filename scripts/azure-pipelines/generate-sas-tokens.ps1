Param(
    [Parameter(Mandatory=$true)]
    [int]$KeyNumber
)

function Get-SasToken {
    Param(
        [Parameter(Mandatory=$true)]
        [int]$KeyNumber,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$StorageAccountName,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$ContainerName,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Permission
    )

    $keys = Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
    $key = $keys[$KeyNumber - 1]
    $ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $key.Value
    $start = Get-Date -AsUTC
    $end = $start.AddDays(90)
    $token = New-AzStorageContainerSASToken -Name $ContainerName -Permission $Permission -StartTime $start -ExpiryTime $end -Context $ctx -Protocol HttpsOnly
    if ($token.StartsWith('?')) {
        $token = $token.Substring(1)
    }

    return $token
}

# Asset Cache:
# Read, Create, List
$assetWus3Sas = Get-SasToken -KeyNumber $KeyNumber -ResourceGroupName vcpkg-asset-cache -StorageAccountName vcpkgassetcachewus3 -ContainerName cache -Permission rcl

# Binary Cache:
# Read, Create, List, Write
$binaryWUS3as = Get-SasToken -KeyNumber $KeyNumber -ResourceGroupName vcpkg-binary-cache -StorageAccountName vcpkgbinarycachewus3 -ContainerName cache -Permission rclw

$response = "Asset Cache SAS: Update`n" + `
    "https://dev.azure.com/vcpkg/public/_library?itemType=VariableGroups&view=VariableGroupView&variableGroupId=6&path=vcpkg-asset-caching-credentials`n" + `
    "and`n" + `
    "https://devdiv.visualstudio.com/DefaultCollection/DevDiv/_library?itemType=VariableGroups&view=VariableGroupView&variableGroupId=355&path=vcpkg-asset-caching-credentials`n" + `
    "`n" + `
    "wus3 token:`n" + `
    "$assetWus3Sas`n" + `
    "`n" + `
    "Binary Cache SAS: Update`n" + `
    "https://dev.azure.com/vcpkg/public/_library?itemType=VariableGroups&view=VariableGroupView&variableGroupId=8&path=vcpkg-binary-caching-credentials`n" + `
    "`n" + `
    "sas-bin-wus3:`n" + `
    "$binaryWUS3as`n"

Write-Host $response
