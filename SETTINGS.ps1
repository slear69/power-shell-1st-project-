
param(
    [Parameter(Mandatory=$true)]
    [int]$size = 16
)
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Write-Host "findeing terminal settings ...." -ForegroundColor Cyan
$jason = Get-Content $settingsPath -Raw | ConvertFrom-Json
Copy-Item -Path $settingsPath -Destination "$settingsPath.bak" -Force

Write-Host "faundit $jason." -ForegroundColor Cyan
if (-not $jason.profiles.defaults){
    Write-Host "makeing a jason.profile file" -ForegroundColor Red
    $jason.profiles | Add-Member -MemberType NoteProperty -Name "defaults" -Value ([PSCustomObject]@{})

}
else{
    Write-Host "jason.profile already exists" -ForegroundColor Green
}

if (-not $jason.profiles.defaults.font){
    Write-Host "loading font file..." -ForegroundColor Red
    $jason.profiles.defaults | Add-Member -MemberType NoteProperty -Name "font" -Value ([PSCustomObject]@{})
}
else {
    Write-Host "jason.profile.font already exists" -ForegroundColor Green
}
# adds a size section to the font section named size
$jason.profiles.defaults.font| Add-Member -MemberType NoteProperty -Name "size" -Value $size -Force

$jason | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Encoding utf8
Write-Host "font size have been changed ! to $size"

