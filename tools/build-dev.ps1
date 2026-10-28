$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$project = Join-Path $repoRoot 'Saucy/Saucy.csproj'

dotnet build $project -c Release
if ($LASTEXITCODE -ne 0) { throw 'Saucy Release build failed.' }

$source = Join-Path $repoRoot 'Saucy/bin/Release'
$destination = Join-Path $repoRoot 'bin/Release'
New-Item -ItemType Directory -Path $destination -Force | Out-Null
Get-ChildItem -LiteralPath $source | Copy-Item -Destination $destination -Recurse -Force
Copy-Item -LiteralPath (Join-Path $repoRoot 'BRAWLER-DEV.md') -Destination $destination -Force
Write-Host "Development plugin: $(Join-Path $destination 'Saucy.dll')"
