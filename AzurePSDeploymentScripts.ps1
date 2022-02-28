Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$PSScriptRoot

Get-ChildItem -Path $PSScriptRoot -Recurse -Include "*.ps1" -Exclude "*AzurePSDeploymentScripts.ps1" | ForEach-Object {
    $ModulePath = $_.Fullname

    . $ModulePath
}
