$mode = Read-Host "wich mode would you like [A]Aoutomatic , [M]Manule"
#===================================VERIABELS================================================================
$git = "$env:ProgramFiles\Git\cmd\git.exe" 
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$jason = Get-Content $settingsPath -Raw | ConvertFrom-Json
$vscodesettings = "$env:APPDATA\Code\User\settings.json"
#==========================================================================================================

#======================================Functions=======================================================================
function gitsetup {
    
    $existingName  = & $git config --global user.name
    $existingEmail = & $git config --global user.email
    $gitname = ""
    $gitgmail = ""
    if(-not $gitname -or -not $gitgmail -and -not $existingName -and -not $existingEmail){
        $gitname = Read-Host " username for your git"
        $gitgmail = Read-Host " Gmail for your git "
    }
    
    & $git config --global user.name $gitname
    & $git config --global user.email $gitgmail
}
function InstallCheckauto{
    param(
        [string]$Name,
        [string]$Id
    )
    winget list --id $Id -e | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "installing $Name"
        winget install --id $Id -e
    }
    else {
        Write-Host "$Name is already installed" -ForegroundColor Green
    }
}
function extantioncheck{
    param(
        [string]$extantion,
        [string]$name
    )
    $installed = code --list-extensions | Select-String -SimpleMatch $extantion

    if ($installed) {
        Write-Host "$name is already installed" -ForegroundColor Green
    }
    else {
        Write-Host "installing $name"
        code --install-extension $extantion
    }
}


#==========================================================================================================
if ($mode -eq "M")
{
    
    InstallCheckauto -Name "Visual Studeo" -Id "Microsoft.VisualStudio.Community"

    InstallCheckauto -Name "Visual Studeo code" -Id "Microsoft.VisualStudioCode"
    
    InstallCheckauto -Name "Git" -Id "Git.Git"

    InstallCheckauto -Name "Python" -Id "Python.Python.3.13"

    InstallCheckauto -Name "Node.js" -Id "OpenJS.NodeJS.LTS"

    InstallCheckauto -Name "Spotify" -Id "Spotify.Spotify"
    if (winget list "Microsoft.VisualStudioCode"){
        extantioncheck -extantion "donjayamanne.python-extension-pack" -name "Python Extension Pack"
        extantioncheck -extantion "hackatime.hackatime-time-tracker" -name "HackTime"
        extantioncheck -extantion "ritwickdey.liveserver" -name "Live Server"
        extantioncheck -extantion "eamodio.gitlens" -name "GitLence"
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
    extantioncheck -extantion "donjayamanne.python-extension-pack" -name "Python Extension Pack"
    extantioncheck -extantion "hackatime.hackatime-time-tracker" -name "HackTime"
    extantioncheck -extantion "ritwickdey.liveserver" -name "Live Server"
    extantioncheck -extantion "eamodio.gitlens" -name "GitLence"
    
    InstallCheckauto -Name "Visual Studeo" -Id "Microsoft.VisualStudio.Community"

    InstallCheckauto -Name "Visual Studeo code" -Id "Microsoft.VisualStudioCode"
    
    InstallCheckauto -Name "Git" -Id "Git.Git"

    InstallCheckauto -Name "Python" -Id "Python.Python.3.13"

    InstallCheckauto -Name "Node.js" -Id "OpenJS.NodeJS.LTS"

    InstallCheckauto -Name "Spotify" -Id "Spotify.Spotify"
    $size = 10
    $savemode="onWindowChange"
    $Theam = "Red"
    $pathbar = $false
    $notify = $false
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
$vsJson | Add-Member -MemberType NoteProperty -Name "editor.fontSize" -Value $size -Force
$vsJson | ConvertTo-Json -Depth 10 | Set-Content -Path $vscodesettings -Encoding utf8
#==================================================================================================


