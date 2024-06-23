<#
============================================================================================================================
Script: VSCode_Profile
Author: Smart Ace Designs

Notes:
This file contains the default profile to be used with Visual Studio Code to support building ScriptoForm executables.
============================================================================================================================
#>

#region Settings
$BuildFolder = "Build"
$CertificateFriendlyName = "PowerShell"
$CLI = "C:\Program Files\dotnet\dotnet.exe"
$Frameworks = @([PSCustomObject]@{Name = "Legacy";Version = "net48";Enabled=$true},
                [PSCustomObject]@{Name = "LTS-Legacy";Version = "net6.0-windows";Enabled=$true},
                [PSCustomObject]@{Name = "LTS";Version = "net8.0-windows";Enabled=$true})
$ProjectFileName = "Build.csproj"
$ReleaseFolder = "Release"
$TimeStampServer = "http://timestamp.digicert.com"
#endregion

#region Main
$SigningCertificate = Get-ChildItem Cert:\CurrentUser\My | Where-Object FriendlyName -eq $CertificateFriendlyName

if (Test-Path -Path $CLI)
{
    Register-EditorCommand -Name BuildScriptoForms -DisplayName 'Build ScriptoForms' -ScriptBlock `
    {
        Clear-Host
        if ($SigningCertificate)
        {
            Write-Host "Signing PowerShell script" -ForegroundColor Green
            $ScriptFile = $psEditor.GetEditorContext().CurrentFile.Path
            [void](Set-AuthenticodeSignature -FilePath $ScriptFile -Certificate $SigningCertificate -TimestampServer $TimeStampServer -HashAlgorithm SHA256)
        }

        Set-Location (Split-Path $ScriptFile -Parent)
        if (Test-Path $BuildFolder\$ProjectFileName)
        {
            Set-Location $BuildFolder
            foreach ($Framework in $Frameworks)
            {
                if ($Framework.Enabled)
                {
                    Write-Host "Building .NET $($Framework.Name) assembly" -ForegroundColor Green
                    (Start-Process -FilePath $CLI -ArgumentList "publish -f $($Framework.Version) -v q -nologo -o ..\$ReleaseFolder\$($Framework.Name)" -PassThru -WindowStyle Hidden).WaitForExit()
                    (Start-Process -FilePath $CLI -ArgumentList "clean -f $($Framework.Version) -v q -nologo" -PassThru -WindowStyle Hidden).WaitForExit()
                }
            }

            if ($SigningCertificate)
            {
                Set-Location (Split-Path $ScriptFile -Parent)
                if (Test-Path $ReleaseFolder)
                {
                    Write-Host "Signing assemblies" -ForegroundColor Green
                    foreach ($File in (Get-ChildItem -Path $ReleaseFolder -Filter "*.exe" -Recurse | Select-Object FullName -ExpandProperty FullName))
                    {
                        [void](Set-AuthenticodeSignature -FilePath $File -Certificate $SigningCertificate -TimestampServer $TimeStampServer -HashAlgorithm SHA256)
                    }
                }
            }
            Clear-Host
        }
        else
        {
            Clear-Host
            Write-Warning "The build directory or project file could not be found.  The build has been cancelled."
        }
    }

    Register-EditorCommand -Name BuildScriptoForm -DisplayName 'Build ScriptoForm' -ScriptBlock `
    {
        Clear-Host
        if ($SigningCertificate)
        {
            Write-Host "Signing PowerShell script" -ForegroundColor Green
            $ScriptFile = $psEditor.GetEditorContext().CurrentFile.Path
            [void](Set-AuthenticodeSignature -FilePath $ScriptFile -Certificate $SigningCertificate -TimestampServer $TimeStampServer -HashAlgorithm SHA256)
        }

        Set-Location (Split-Path $ScriptFile -Parent)
        if (Test-Path $BuildFolder\$ProjectFileName)
        {
            Set-Location $BuildFolder
            Write-Host "Building .NET assembly" -ForegroundColor Green
            (Start-Process -FilePath $CLI -ArgumentList "publish -f net8.0-windows -v q -nologo -o ..\$ReleaseFolder" -PassThru -WindowStyle Hidden).WaitForExit()
            (Start-Process -FilePath $CLI -ArgumentList "clean -f net8.0-windows -v q -nologo" -PassThru -WindowStyle Hidden).WaitForExit()
            

            if ($SigningCertificate)
            {
                Set-Location (Split-Path $ScriptFile -Parent)
                if (Test-Path $ReleaseFolder)
                {
                    Write-Host "Signing assemblies" -ForegroundColor Green
                    foreach ($File in (Get-ChildItem -Path $ReleaseFolder -Filter "*.exe" -Recurse | Select-Object FullName -ExpandProperty FullName))
                    {
                        [void](Set-AuthenticodeSignature -FilePath $File -Certificate $SigningCertificate -TimestampServer $TimeStampServer -HashAlgorithm SHA256)
                    }
                }
            }
            Clear-Host
        }
        else
        {
            Clear-Host
            Write-Warning "The build directory or project file could not be found.  The build has been cancelled."
        }
    }
}

if ($SigningCertificate)
{
    Register-EditorCommand -Name SignScript -DisplayName 'Sign Script' -ScriptBlock `
    {
        Clear-Host
        Write-Host "Signing PowerShell script" -ForegroundColor Green
        $ScriptFile = $psEditor.GetEditorContext().CurrentFile.Path
        Set-Location (Split-Path $ScriptFile -Parent)
        [void](Set-AuthenticodeSignature -FilePath $ScriptFile -Certificate $SigningCertificate -TimestampServer $TimeStampServer -HashAlgorithm SHA256)
        Clear-Host
    }
}
#endregion
