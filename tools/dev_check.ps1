[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $repoRoot

$venvPython = Join-Path $repoRoot ".venv\Scripts\python.exe"
if (Test-Path -LiteralPath $venvPython) {
    $pythonExe = $venvPython
} else {
    $pythonExe = (Get-Command python -ErrorAction Stop).Source
}

$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"

function Invoke-PythonStep {
    param(
        [Parameter(Mandatory)]
        [string]$Label,
        [Parameter(Mandatory)]
        [string[]]$Arguments
    )

    Write-Host "==> $Label"
    & $script:pythonExe @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$Label failed with exit code $LASTEXITCODE"
    }
}

$pythonTools = @(
    "tools\check_upstream_updates.py",
    "tools\check_dependency_freshness.py",
    "tools\check_links.py",
    "tools\validate_skills.py"
)

Invoke-PythonStep -Label "Compile maintained Python" -Arguments (
    @("-m", "compileall", "-q", "tests") + $pythonTools
)
Invoke-PythonStep -Label "Ruff (E9 + F)" -Arguments @(
    "-m", "ruff", "check", "--select", "E9,F", "--target-version", "py39",
    "tests", "tools\check_upstream_updates.py", "tools\check_dependency_freshness.py",
    "tools\check_links.py", "tools\validate_skills.py"
)
Invoke-PythonStep -Label "Pytest" -Arguments @("-m", "pytest", "tests", "-q")
Invoke-PythonStep -Label "Validate skills" -Arguments @(
    "tools\validate_skills.py"
)

$nodeExe = (Get-Command node -ErrorAction Stop).Source
$cliDir = Join-Path $repoRoot "tools\clis"
$cliFiles = Get-ChildItem -LiteralPath $cliDir -Filter "*.js" -File
if (-not $cliFiles) {
    throw "No CLI scripts found under tools\clis"
}
Write-Host "==> Node syntax check ($($cliFiles.Count) CLIs)"
foreach ($cli in $cliFiles) {
    & $nodeExe --check $cli.FullName
    if ($LASTEXITCODE -ne 0) {
        throw "node --check failed for $($cli.Name) with exit code $LASTEXITCODE"
    }
}

Invoke-PythonStep -Label "Check Markdown links" -Arguments @(
    "tools\check_links.py"
)

Write-Host "WINDOWS DEV CHECK GREEN"
