$projectpath = "C:\Users\astey\Documents\Black Ops 2 - GSC Studio\Loki's Ragnarok"
Set-Location -Path "$projectpath"
$repopath = "C:\Users\astey\Documents\GitHub\LokisRagnarok"
$scriptname = "Loki-Ragnarok"
$lrzpath = "$projectpath\ZM"
$lrz_main = "$lrzpath\src\main.gsc"
$lrz_versionp1 = Select-String '(.\..\..)'-Path "$lrz_main"
$lrz_version = $lrz_versionp1.Matches.value
$lrz_versioncheck = Get-Content ./logs/lrz-version.log

$lrmppath = "$projectpath\MP"
$lrmp_main = "$lrmppath\src\main.gsc"
$lrmp_versionp1 = Select-String '(.\..\..)'-Path "$lrmp_main"
$lrmp_version = $lrmp_versionp1.Matches.value
$lrmp_versioncheck = Get-Content ./logs/lrmp-version.log

Write-Output "-----------------=========================================================---------------------"
New-Item -ItemType Directory -Path ZM\src-compiled -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path ZM\src -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path ZM\Uncompiled -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path MP\src-compiled -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path MP\src -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path MP\Uncompiled -ErrorAction SilentlyContinue
Write-Output "GSC Autocompiler - By @DoktorSAS & TheFantasticLoki"

try
{
    if(Test-Path -Path .\ZM\src\main.gsc)
    {
        Write-Output "Loading LRZ main script file and all other files"
        Rename-Item -Path "$($lrzpath)\src\main.gsc" -NewName "$($lrzpath)\src\1-main.gsc" -Force
        cmd /c "copy /B /Y ZM\src\*.gsc ZM\lrz-uncompiled.gsc"
        Rename-Item -Path "$($lrzpath)\src\1-main.gsc" -NewName "$($lrzpath)\src\main.gsc" -Force
        Write-Output "Main files Loaded"
        Write-Output "*.gsc files loaded"
        Copy-Item .\ZM\lrz-uncompiled.gsc "$($lrzpath)\Uncompiled\lrz-uncompiled.gsc" -Force
        if(Test-Path -Path $lrzpath\lrz-compile.log)
        {
            cmd /c "del ZM\lrz-compile.log"
        }
        Start-Process .\compiler\gsc-tool.exe -ArgumentList "comp t6 `"$($lrzpath)\lrz-uncompiled.gsc`"" -Wait -NoNewWindow -RedirectStandardError "$($lrzpath)\lrz-compile.log"
        if (Select-String -NotMatch "ERROR" -InputObject "$($lrzpath)\lrz-compile.log")
        {
            if (Test-Path -Path .\ZM\lrz-compiled.gsc)
            {
                Write-Output "Deleting old compiled file"
                cmd /c "del ZM\lrz-compiled.gsc"
            }
            Rename-Item -Path "$($lrzpath)\lrz-uncompiled.gsc" -NewName "$($lrzpath)\lrz-compiled.gsc" -Force
        }
        Write-Output "Main Compile phase ended"
        Write-Output "Compiling copy of src folder"
        Copy-Item -Path ".\ZM\src\*.gsc" -Destination ".\ZM\src-compiled" -Force > $null
        Start-Process .\compiler\gsc-tool.exe -ArgumentList "comp t6 `"$($lrzpath)\src-compiled`"" -Wait -NoNewWindow 
        Write-Output "Compiled Source Code Please Check for Errors"
        if (Test-Path -Path "$($env:LOCALAPPDATA)\Plutonium\storage\t6\scripts\zm\$($scriptname)V$($lrz_versioncheck).gsc") 
        {
            Write-Output "Removing old $($scriptname)V$($lrz_version).gsc"
            if (Test-Path -Path "$($env:LOCALAPPDATA)\Plutonium\storage\t6\scripts\zm\$($scriptname)V$($lrz_versioncheck).gsc.bak")
            {
                Remove-Item -Path "$($env:LOCALAPPDATA)\Plutonium\storage\t6\scripts\zm\$($scriptname)V$($lrz_versioncheck).gsc.bak"
            }
            Rename-Item -Path "$env:LOCALAPPDATA\Plutonium\storage\t6\scripts\zm\$($scriptname)V$($lrz_versioncheck).gsc" -NewName "$($scriptname)V$($lrz_versioncheck).gsc.bak" -Force
        }
        Copy-Item -Path ".\ZM\lrz-compiled.gsc" -Destination "$($env:LOCALAPPDATA)\Plutonium\storage\t6\scripts\zm\$($scriptname)V$($lrz_version).gsc" -Force 
        Write-Output "File moved in Plutonium ZM folder"
        if (Test-Path -Path "$($repopath)\scripts\zm\$($scriptname)V$($lrz_versioncheck).gsc") 
        {
            Write-Output "Removing old $($scriptname)V$($lrz_versioncheck).gsc"
            if (Test-Path -Path "$($repopath)\scripts\zm\$($scriptname)V$($lrz_versioncheck).gsc.bak")
            {
                Remove-Item -Path "$($repopath)\scripts\zm\$($scriptname)V$($lrz_versioncheck).gsc.bak"
            }
            Rename-Item -Path "$($repopath)\scripts\zm\$($scriptname)V$($lrz_versioncheck).gsc" -NewName "$($scriptname)V$($lrz_versioncheck).gsc.bak" -Force
        }
        Copy-Item -Path ".\ZM\lrz-compiled.gsc" "$($repopath)\scripts\zm\$($scriptname)V$($lrz_version).gsc" -Force 
        Write-Output "File moved in Repo folder"
        $lrz_version > .\logs\lrz-version.log

        if (Select-String -NotMatch "ERROR" -InputObject "$($lrzpath)\lrz-compile.log")
        {
            Write-Output "File compiled as intended"
            Add-Type -AssemblyName System.Windows.Forms 
            $global:balloon = New-Object System.Windows.Forms.NotifyIcon
            $path = (Get-Process -id $pid).Path
            $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
            $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info 
            $balloon.BalloonTipText = 'File compiled as intended'
            $currentPathLocation = Split-Path -Path $pwd -Leaf
            $balloon.BalloonTipTitle = "$scriptname ZM Compiled!" 
            $balloon.Visible = $true 
            $balloon.ShowBalloonTip(5000)
        }
        if (Select-String "ERROR" -InputObject "$($lrzpath)\lrz-compile.log")
        {
            Write-Output "There is an error in the source code"
            Add-Type -AssemblyName System.Windows.Forms 
            $global:balloon = New-Object System.Windows.Forms.NotifyIcon
            $path = (Get-Process -id $pid).Path
            $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
            $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning 
            $balloon.BalloonTipText = 'There is an error in the source code'
            $currentPathLocation = Split-Path -Path $pwd -Leaf
            $balloon.BalloonTipTitle = "$scriptname ZM not Compiled!" 
            $balloon.Visible = $true 
            $balloon.ShowBalloonTip(5000)
        }
    }
    if(Test-Path -Path .\MP\src\main.gsc)
    {
        Write-Output "Loading LRMP main script file and all other files"
        Rename-Item -Path "$($lrmppath)\src\main.gsc" -NewName "$($lrmppath)\src\1-main.gsc" -Force
        cmd /c "copy /B /Y MP\src\*.gsc MP\lrmp-uncompiled.gsc"
        Rename-Item -Path "$($lrmppath)\src\1-main.gsc" -NewName "$($lrmppath)\src\main.gsc" -Force
        Write-Output "Main files Loaded"
        Write-Output "*.gsc files loaded"
        Copy-Item .\MP\lrmp-uncompiled.gsc "$($lrmppath)\Uncompiled\lrmp-uncompiled.gsc" -Force
        if(Test-Path -Path $lrmppath\lrmp-compile.log)
        {
            cmd /c "del MP\lrmp-compile.log"
        }
        Start-Process .\compiler\gsc-tool.exe -ArgumentList "comp t6 `"$($lrmppath)\lrmp-uncompiled.gsc`"" -Wait -NoNewWindow -RedirectStandardError "$($lrmppath)\lrmp-compile.log"
        if (Select-String -NotMatch "ERROR" -InputObject "$($lrmppath)\lrmp-compile.log")
        {
            if (Test-Path -Path .\MP\lrmp-compiled.gsc)
            {
                Write-Output "Deleting old compiled file"
                cmd /c "del MP\lrmp-compiled.gsc"
            }
            Rename-Item -Path "$($lrmppath)\lrmp-uncompiled.gsc" -NewName "$($lrmppath)\lrmp-compiled.gsc" -Force
        }
        Write-Output "Main Compile phase ended"
        Write-Output "Compiling copy of src folder"
        Copy-Item -Path .\MP\src\*.gsc -Destination .\MP\src-compiled -Force > $null
        Start-Process .\compiler\gsc-tool.exe -ArgumentList "comp t6 `"$($lrmppath)\src-compiled`"" -Wait -NoNewWindow 
        Write-Output "Compiled Source Code Please Check for Errors"
        if (Test-Path -Path "$($env:LOCALAPPDATA)\Plutonium\storage\t6\scripts\mp\$($scriptname)V*.gsc") 
        {
            Write-Output "Removing old $($scriptname)V$($lrmp_versioncheck).gsc"
            if (Test-Path -Path "$($env:LOCALAPPDATA)\Plutonium\storage\t6\scripts\mp\$($scriptname)V$($lrmp_versioncheck).gsc.bak")
            {
                Remove-Item -Path "$($env:LOCALAPPDATA)\Plutonium\storage\t6\scripts\mp\$($scriptname)V$($lrmp_versioncheck).gsc.bak"
            }
            Rename-Item -Path "$($env:LOCALAPPDATA)\Plutonium\storage\t6\scripts\mp\$($scriptname)V$($lrmp_versioncheck).gsc" -NewName "$($scriptname)V$($lrmp_versioncheck).gsc.bak" -Force
        }
        Copy-Item -Path ".\MP\lrmp-compiled.gsc" "$($env:LOCALAPPDATA)\Plutonium\storage\t6\scripts\mp\$($scriptname)V$($lrmp_version).gsc" -Force 
        Write-Output "File moved in Plutonium MP folder"
        if (Test-Path -Path "$($repopath)\scripts\mp\$($scriptname)V$($lrmp_versioncheck).gsc") 
        {
            Write-Output "Removing old $($scriptname)V$($lrmp_versioncheck).gsc"
            if (Test-Path -Path "$($repopath)\scripts\mp\$($scriptname)V$($lrmp_versioncheck).gsc.bak")
            {
                Remove-Item -Path "$($repopath)\scripts\mp\$($scriptname)V$($lrmp_versioncheck).gsc.bak"
            }
            Rename-Item -Path "$($repopath)\scripts\mp\$($scriptname)V$($lrmp_versioncheck).gsc" -NewName "$($scriptname)V$($lrmp_versioncheck).gsc.bak" -Force
        }
        Copy-Item -Path ".\MP\lrmp-compiled.gsc" -Destination "$($repopath)\scripts\mp\$($scriptname)V$($lrmp_version).gsc" -Force 
        Write-Output "File moved in Repo folder"
        $lrmp_version > .\logs\lrmp-version.log

        if (Select-String -NotMatch "ERROR" -InputObject "$($lrmppath)\lrmp-compile.log")
        {
            Write-Output "File compiled as intended"
            Add-Type -AssemblyName System.Windows.Forms 
            $global:balloon = New-Object System.Windows.Forms.NotifyIcon
            $path = (Get-Process -id $pid).Path
            $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
            $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info 
            $balloon.BalloonTipText = 'File compiled as intended'
            $currentPathLocation = Split-Path -Path $pwd -Leaf
            $balloon.BalloonTipTitle = "$scriptname MP Compiled!" 
            $balloon.Visible = $true 
            $balloon.ShowBalloonTip(5000)
        }
        if (Select-String "ERROR" -InputObject "$($lrmppath)\lrmp-compile.log")
        {
            Write-Output "There is an error in the source code"
            Add-Type -AssemblyName System.Windows.Forms 
            $global:balloon = New-Object System.Windows.Forms.NotifyIcon
            $path = (Get-Process -id $pid).Path
            $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
            $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning 
            $balloon.BalloonTipText = 'There is an error in the source code'
            $currentPathLocation = Split-Path -Path $pwd -Leaf
            $balloon.BalloonTipTitle = "$scriptname MP not Compiled!" 
            $balloon.Visible = $true 
            $balloon.ShowBalloonTip(5000)
        }
    }
    else
    {
        Write-Output "Missing main.gsc"
        Add-Type -AssemblyName System.Windows.Forms 
        $global:balloon = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
        $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning 
        $balloon.BalloonTipText = 'Missing file main.gsc'
        $currentPathLocation = Split-Path -Path $pwd -Leaf
        $balloon.BalloonTipTitle = "Unable to compile the $currentPathLocation" 
        $balloon.Visible = $true 
        $balloon.ShowBalloonTip(5000)
    }
}
catch 
{
    if(-not(Test-Path -Path .\compiler\gsc-tool.exe) )
    {
        Write-Output "I am not allowed to share the compiler for gsc scripts."
        Write-Output "This means that the compiler folder will be empty and you'll have to manually insert the two files provided by the Plutonium team."
        Write-Output "The two files to insert are in the GSC Compiler folder`n`t1) Compiler.exe`n`t2) Irony.dll"
        sleep 5
        Add-Type -AssemblyName System.Windows.Forms 
        $global:balloon = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
        $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error 
        $balloon.BalloonTipText = 'Missing compiler.exe or Irony.dll'
        $currentPathLocation = Split-Path -Path $pwd -Leaf
        $balloon.BalloonTipTitle = "Unable to execute the compiler" 
        $balloon.Visible = $true 
        $balloon.ShowBalloonTip(5000)
        Start-Process "https://drive.google.com/file/d/1j_ocjFCQsFaWqF2-PfdoJt2nF_EpNL_G/view"
    }
    else
    {
        Add-Type -AssemblyName System.Windows.Forms 
        $global:balloon = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
        $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error 
        $balloon.BalloonTipText = 'Something threw an exception'
        $currentPathLocation = Split-Path -Path $pwd -Leaf
        $balloon.BalloonTipTitle = "Unable to compile the $currentPathLocation" 
        $balloon.Visible = $true 
        $balloon.ShowBalloonTip(5000)
        Write-Output "Something threw an exception"
        Write-Output $_
    }
    
}

Write-Output "-----------------=========================================================---------------------"