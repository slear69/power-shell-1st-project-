$mode = Read-Host "wich mode would you like [A]Aoutomatic , [M]Manule"
#===================================VERIABELS================================================================
$git = "$env:ProgramFiles\Git\cmd\git.exe" 
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$jason = Get-Content $settingsPath -Raw | ConvertFrom-Json
$vscodesettings = "$env:APPDATA\Code\User\settings.json"
#==========================================================================================================

if ($mode -eq "M")
{

    winget list --id Microsoft.VisualStudio.Community | Out-Null
    if($LASTEXITCODE -ne 0){
        Write-Host "insatlling vs"
        winget install --id Microsoft.VisualStudio.Community
    }
    else{
        Write-Host "Founde visual Studeo" -ForegroundColor Green
    }


    winget list --id Microsoft.VisualStudioCode | Out-Null
    if($LASTEXITCODE -ne 0){
        Write-Host "insatlling vs code"
        winget install --id Microsoft.VisualStudioCode
    }
    else{
        Write-Host "Founde visual Studeo code" -ForegroundColor Green
    }

    winget list --id Git.Git | Out-Null
    if($LASTEXITCODE -ne 0){
        Write-Host "insatlling Git"
        winget install --id Git.Git
    }
    else{
        Write-Host "Founde git " -ForegroundColor Green
    }



    if (Test-Path $vscodesettings) {
        Write-Host " Found VS Code settings: $vscodesettings" 
    }
    else {
        Write-Host "VS Code settings not found, creating it..." -ForegroundColor Red
        New-Item -ItemType Directory -Path (Split-Path $vscodesettings) -Force | Out-Null
        Set-Content -Path $vscodesettings -Value "{}"
    }



    $save = Read-Host "how loude you like to save the files [A]AutoDali , [O]Off , [W]OfWindollsChange,[F]OfFoucseChange"
    $savemode=""
    if($save -eq "A"){
        $savemode = "afterDelay"
    }
    elseif ($save -eq "O") {
        $savemode = "off"
    }
    elseif ($save -eq "W") {
        $savemode = "onWindowChange"
    }
    elseif ($save -eq "F") {
        $savemode = "onFocusChange"
    }

    $Theam = Read-Host "
    Theames wich one wloude you like :
    Default Dark Modern
    Default Light Modern
    Default Dark+
    Default Light+
    Visual Studio Dark
    Visual Studio Light
    Default High Contrast
    Default High Contrast Light
    Monokai
    Monokai Dimmed
    Solarized Dark
    Solarized Light
    Quiet Light
    Abyss
    Kimbie Dark
    Red
    Tomorrow Night Blue
    (TYPE AS IS !!!!) Or skip to keep the defult"
    $pathbar = $false
    $Link = $true
    $check = Read-Host "Do you want the are you sure notifications for visual studeo code  [Y]yes , [N]no"
    if($check -eq "N"){
        $notify = $false
    }
    [int]$size = Read-Host "size of the font"
    gitsetup
    
}
elseif ($mode -eq "A") {
    $size = 10
    $savemode="onWindowChange"
    $Theam = "Red"
    $pathbar = $false
    $Link = $true
}


#===========================Terminal===================================================================
if (-not $jason.profiles.defaults) {
    Write-Host "making defaults section..." -ForegroundColor Red
    $jason.profiles | Add-Member -MemberType NoteProperty -Name "defaults" -Value ([PSCustomObject]@{}) -Force
}
else {
    Write-Host "defaults already exists" -ForegroundColor Green
}

# sets font (replaces it if it is empty or missing)
$jason.profiles.defaults | Add-Member -MemberType NoteProperty -Name "font" -Value ([PSCustomObject]@{ size = $size }) -Force
Write-Host "font size has been changed to $size" -ForegroundColor Green

$jason | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Encoding utf8
Write-Host $jason.profiles.defaults 
#=================================================================================================================

#====================vscode=======================================================================
Copy-Item -Path $settingsPath -Destination "$settingsPath.bak" -Force
$vsJson = Get-Content -LiteralPath $vscodesettings -Raw | ConvertFrom-Json
$vsJson | Add-Member -MemberType NoteProperty -Name "files.autoSave" -Value $savemode -Force
$vsJson | Add-Member -MemberType NoteProperty -Name "workbench.colorTheme" -Value $Theam -Force
$vsJson | Add-Member -MemberType NoteProperty -Name "breadcrumbs.enabled" -Value $pathbar -Force
$vsJson | Add-Member -MemberType NoteProperty -Name "editor.linkedEditing" -Value $Link -Force
$vsJson | Add-Member -MemberType NoteProperty -Name "explorer.confirmDelete" -Value $notify -Force
$vsJson | ConvertTo-Json -Depth 10 | Set-Content -Path $vscodesettings -Encoding utf8
#==================================================================================================
function gitsetup {
    $gitname = Read-Host " username for your git"
    $gitgmail = Read-Host " Gmail for your git "
    if(-not $gitname -or -not $gitgmail){
        Write-Host"Wrtie a usernam or gamil" -ForegroundColor Red
        $gitname = Read-Host " username for your git"
        $gitgmail = Read-Host " Gmail for your git "
    }
    
    & $git config --global user.name $gitname
    & $git config --global user.email $gitgmail
}
