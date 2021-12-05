$ShouldDownloadLatest = 1
# invoke uccp to get the version
# $UccpExists = Test-Path -Path .\uccp.exe -PathType Leaf
# if ($UccpExists)
# {
#     $VersionArgs = { .\uccp.exe --version }
#     Invoke-Command -ScriptBlock $VersionArgs
# }
$Response = Invoke-WebRequest -Uri 'https://api.github.com/repos/DarklightGames/uccp/releases/latest' -UseBasicParsing
$Content = $Response.Content | ConvertFrom-Json
$Version = $Content.name 
Write-Output "Downloading uccp $Version"
if ($ShouldDownloadLatest)
{
    $DownloadUrl = $Content.assets.browser_download_url
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($DownloadUrl, ".\uccp.exe")
    Write-Output "Done"
}