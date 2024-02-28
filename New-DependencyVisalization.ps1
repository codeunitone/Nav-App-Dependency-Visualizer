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

$MarkdownContent = "``````mermaid`n"
$MarkdownContent += "graph $OrientationMapped`n"

Get-ChildItem -Path $Path -Recurse -Filter 'app.json' | ForEach-Object {
    $appJson = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
    $MermaidGraph += "  $(($appJson.name).replace(' ','_'))`n"
    foreach ($dependency in $appJson.dependencies) {
        $MermaidGraph += "  $(($appJson.name).replace(' ','_')) --> $(($dependency.name).replace(' ','_'))`n"
    }
}

if ($MermaidGraph) {
    $MarkdownContent += "$MermaidGraph`n"
    $MarkdownContent += "``````"

    $OutputFile = Join-Path -Path $OutputPath -ChildPath "DependencyVisualization.md"
    $MarkdownContent | Out-File -FilePath "$OutputFile"
    Write-Host "Graph created at $OutputFile"
}
else {
    Write-Host "No app.json files found"
}