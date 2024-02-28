<#
.SYNOPSIS
    This script generates a dependency graph of NAV/BC apps with mermaid.

.DESCRIPTION
    New-DependencyVisalization.ps1 is a PowerShell script that generates a dependency graph for a given directory of 
    NAV/BC app.json files. 
    It uses the Mermaid graph syntax to represent dependencies.

.PARAMETER Path
    The directory path where the script will search for the app.json files.

.PARAMETER Orientation
    The orientation of the graph. It can be either "TopDown" or "LeftRight". Default is "TopDown".

.PARAMETER OutputPath
    The directory path where the output will be saved. Default is the script's current directory.

.EXAMPLE
    .\New-DependencyVisalization.ps1 -Path .\appjson_files -Orientation TopDown -OutputPath .\output
    This command will generate a top-down dependency graph for the app.json files in the `appjson_files` directory and save the output in the `output` directory.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]
    $Path,

    [ValidateSet("TopDown", "LeftRight")]
    [string]
    $Orientation = "TopDown",

    [string]
    $OutputPath = "$PSScriptRoot"
)

$ErrorActionPreference = "Stop"

switch ($Orientation) {
    "TopDown" { $OrientationMapped = "TD" }
    "LeftRight" { $OrientationMapped = "LR" }
}

Get-ChildItem -Path $Path -Recurse -Filter 'app.json' | ForEach-Object {
    $appJson = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
    $MermaidGraph += "  $(($appJson.name).replace(' ','_'))`n"
    foreach ($dependency in $appJson.dependencies) {
        $MermaidGraph += "  $(($appJson.name).replace(' ','_')) --> $(($dependency.name).replace(' ','_'))`n"
    }
}

if ($MermaidGraph) {
    $MermaidGraph = "graph $OrientationMapped`n$MermaidGraph"

    $OutputFile = Join-Path -Path $OutputPath -ChildPath "DependencyVisualization.mmd"
    $MermaidGraph | Out-File -FilePath "$OutputFile"
    Write-Host "Graph created at $OutputFile"
}
else {
    Write-Host "No app.json files found"
}