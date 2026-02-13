param(
    [Parameter(Mandatory=$true)]
    [string]$ConfigPath
)

# Validate the file exists
if (-not (Test-Path -Path $ConfigPath)) {
    Write-Error "File not found: $ConfigPath"
    exit 1
}

# Read the file content
$content = Get-Content -Path $ConfigPath -Raw

# Remove the [WindowPositions] section and everything until the next section or EOF
$content = [regex]::Replace(
    $content,
    '\[WindowPositions\](\r?\n.*?)*?\r?\n(?=(\[|$))',
    '',
    [System.Text.RegularExpressions.RegexOptions]::Multiline
)

# Write the modified content back
Set-Content -Path $ConfigPath -Value $content

exit 0
