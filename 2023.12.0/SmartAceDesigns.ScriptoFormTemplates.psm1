<#
============================================================================================================================
Module: SmartAceDesigns.ScriptoFormTemplates
Author: Smart Ace Designs

Notes:
This module provides a method for generating a new ScriptoForm project from a custom template using Plaster.
============================================================================================================================
#>

function New-SADScriptoFormProject
{
    <#
    .SYNOPSIS
    Generates a new ScriptoForm project from a custom template using the Plaster PowerShell module.

    .DESCRIPTION
    This function generates a new ScriptoForm project based on a custom template.  A ScriptoForm is a PowerShell script that generates and displays a Microsoft WinForms application that can be used for a specific management or system administration task in a computer network environment. Typically, a ScriptoForm is compiled into an executable file which hides the PowerShell console window during execution and provides a more seamless and familiar experience to the user.
    
    A ScriptoForm project is the set of files and folders including the PowerShell script, typically stored in a GIT repository, that are used to compile the executable file using the Microsoft .NET CLI utility (dotnet.exe) which is available with any Microsoft .NET SDK. The ScriptoForm project includes a C# file which the compiler will use as the source for the executable, and a C# project file (csproj file) which provides the set of instructions used to compile the executable.
    
    A ScriptoForm project consists of the following folder structure:

    ScriptoFormName
    |--Build
       | Build.cs
       | Build.csproj
    | .gitignore
    | Readme.md
    | ScriptoFormName.ps1

    If Visual Studio Code is installed, it will be opened to the new project directory location after the directory structure is created.

    .PARAMETER Size
    Specifies the initial size of the ScriptoForm to generate.  The following pre-configred sizes are available to select:

    Large:       Used to build a general purpose ScriptoForm using a large sized form
    Medium:      Used to build a general purpose ScriptoForm using a medium sized form
    Small:       Used to build a general purpose ScriptoForm using a small sized form

    .PARAMETER DestinationPath
    Specifies the root destination path of the new ScriptoForm project directory.  A directory, using the value of the "Name" parameter, will be created under this path to hold the project files.

    .PARAMETER Name
    Specifies the name of PowerShell script as well as the name of the project directory.  As a best practice, this name should describe what the script does in VERB-NOUN format.  The name will be substituted into various locations within the project such as the Readme.md file and the comments section of the PowerShell script.

    .PARAMETER Author
    Specifies the ScriptoForm author that will be substituted into the comments section of the PowerShell script.  By default this parameter will be set to the Git user name or the current user login name if Git is not installed.

    .PARAMETER NoLogo
    Specifies if the Plaster logo is shown during function execution.

    .EXAMPLE
    PS C:\>New-SADScriptoFormProject -Size Small -DestinationPath $HOME\Desktop -Name Show-SmallForm

    Description
    -----------
    Deploys a new small sized ScriptoForm project named "Show-SmallForm" on the users desktop in the "Show-SmallForm" directory.  If Git is installed, the Git user name will be used as the author name in the project.
    If Git is not installed, the current user login name will be used instead.

    .EXAMPLE
    PS C:\>New-SADScriptoFormProject -Size Medium -DestinationPath $HOME\Desktop -Name Show-MediumForm

    Description
    -----------
    Deploys a new medium sized ScriptoForm project named "Show-MediumForm" on the users desktop in the "Show-MediumForm" directory.  If Git is installed, the Git user name will be used as the author name in the project.
    If Git is not installed, the current user login name will be used instead.

    .LINK
    https://github.com/PowerShellOrg/Plaster
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false, Position = 0)] [ValidateSet("Small","Medium","Large")] [string]$Size = "Medium",
        [Parameter(Mandatory = $false, Position = 1)] [string]$DestinationPath = "$HOME\Desktop",
        [Parameter(Mandatory = $false, Position = 2)] [string]$Name = "Show-DemoForm",
        [Parameter(Mandatory = $false, Position = 3)] [string]$Author,
        [Parameter(Mandatory = $false, Position = 4)] [switch]$NoLogo
    )

    if (!$Author)
    {
        if (Get-Command git -ErrorAction SilentlyContinue)
        {
            $Author = git config user.name
        }
        else {$Author = $env:USERNAME}
    }

    switch ($Size)
    {
        Small  {$FormHeight = 210}
        Medium {$FormHeight = 260}
        Large  {$FormHeight = 370}
    }

    $PlasterParameters = @{
        TemplatePath = "$PSScriptRoot\Templates\General"
        DestinationPath = "$DestinationPath\$Name"
        Name = $Name
        Author = $Author
        NoLogo = $NoLogo
        FormHeight = $FormHeight
    }

    Clear-Host
    Invoke-Plaster @PlasterParameters

    Set-Location -Path $DestinationPath\$Name
    if (Get-Command code -ErrorAction SilentlyContinue)
    {
        code $DestinationPath\$Name --profile "Default"
    }
    else
    {
        powershell_ise.exe "$Name.ps1"
    }
}

function Build-SADScriptoFormExecutable
{
    <#
    .SYNOPSIS
    Compiles a ScriptoForm project located in the current working directory into a executable file.

    .DESCRIPTION
    This function performs the following steps for building a ScriptoForm assembly:
    - Searches the current working directory for PowerShell script files and digitally signs each one found if an appropriate code-signing certificate is available.
    - Searches the current working directory for the Microsoft .NET build files and compiles the specified PowerShell script into a executable for each build target specified.
    - Searches the current working directory for compiled executable files and digitally signs each one found if an appropriate code-signing certificate is available.

    .PARAMETER BuildTarget
    Specifies the .NET target framework to use for build the executable(s).  Selecting "All" (the default value) will compile the an executable for all available frameworks.
    
    .PARAMETER BuildFolder
    Specifies the path to the Microsoft .NET build files.

    .PARAMETER CertificateFriendlyName
    Specifies the friendly name of the code-signing certificate.

    .PARAMETER CLI
    Specifies the path to the Microsoft .NET CLI used for compiling the executable(s).

    .PARAMETER ProjectFileName
    Specifies the path to the project file used to provide build instructions for the Microsoft .NET CLI.

    .PARAMETER ReleaseFolder
    Specifies the path to the target folder for the executable(s).

    .PARAMETER TimeStampServer
    Specifies the URL to the time stamp web server used for digitally signing files.

    .EXAMPLE
    PS C:\>Build-SADScriptoFormExecutable

    Description
    -----------
    Invokes the build process using all default parameters and targets all available Microsoft .NET frameworks.

    .EXAMPLE
    PS C:\>Build-SADScriptoFormExecutable -CertificateFriendlyName "CodeSigningCert"

    Description
    -----------
    Invokes the build process using a custom certificate with the friendly name "CodeSigningCert".

    .EXAMPLE
    PS C:\>Build-SADScriptoFormExecutable -BuildTarget Legacy

    Description
    -----------
    Invokes the build process using all default parameters but targets only the legacy .NET 4 framework.
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false, Position = 0)] [ValidateSet("All","Legacy","LTS-Legacy","LTS","STS")] [string]$BuildTarget = "All",
        [Parameter(Mandatory = $false, Position = 1)] [string]$BuildFolder = "Build",
        [Parameter(Mandatory = $false, Position = 2)] [string]$CertificateFriendlyName = "PowerShell",
        [Parameter(Mandatory = $false, Position = 3)] [string]$CLI = "dotnet.exe",
        [Parameter(Mandatory = $false, Position = 4)] [string]$ProjectFileName = "Build.csproj",
        [Parameter(Mandatory = $false, Position = 5)] [string]$ReleaseFolder = "Release",
        [Parameter(Mandatory = $false, Position = 6)] [string]$TimeStampServer = "http://timestamp.digicert.com"
    )

    if (Get-Command -Name $CLI -ErrorAction SilentlyContinue)
    {
        $Frameworks = @([PSCustomObject]@{Name = "Legacy";Version = "net48";Enabled=$false},
                        [PSCustomObject]@{Name = "LTS-Legacy";Version = "net6.0-windows";Enabled=$false},
                        [PSCustomObject]@{Name = "STS";Version = "net7.0-windows";Enabled=$false},
                        [PSCustomObject]@{Name = "LTS";Version = "net8.0-windows";Enabled=$false})
    
        if ($BuildTarget -eq "All")
        {
            foreach ($Framework in $Frameworks) {$Framework.Enabled = $true}
        }
        else
        {
            foreach ($Framework in $Frameworks)
            {
                if ($Framework.Name -eq $BuildTarget) {$Framework.Enabled = $true}
            }
        }
    }
    else
    {
        Clear-Host
        Write-Warning -Message "The Microsoft.NET SDK is not installed.  Operation has been cancelled."
        break
    }

    Clear-Host
    if (Test-Path $BuildFolder\$ProjectFileName)
    {
        $Message = "Smart Ace Designs"
        $Width = $Host.UI.RawUI.WindowSize.Width
        Write-Host
        Write-Host ((" " * ($Width - $Message.Length)) + $Message) -ForegroundColor Yellow
        Write-Host ("=" * $Width)           
        $SigningCertificate = Get-ChildItem Cert:\CurrentUser\My | Where-Object FriendlyName -eq $CertificateFriendlyName
        
        if ($SigningCertificate)
        {
            Write-Host "Signing script files" -ForegroundColor Yellow
            foreach ($ScriptFile in (Get-ChildItem -Filter "*.ps1" | Select-Object FullName -ExpandProperty FullName))
            {
                [void](Set-AuthenticodeSignature -FilePath $ScriptFile -Certificate $SigningCertificate -TimestampServer $TimeStampServer -HashAlgorithm SHA256)
            }
        }
        
        Push-Location
        Set-Location $BuildFolder
        foreach ($Framework in $Frameworks)
        {
            if ($Framework.Enabled)
            {
                Write-Host "Building .NET $($Framework.Name) Assembly" -ForegroundColor Yellow
                (Start-Process -FilePath $CLI -ArgumentList "publish -f $($Framework.Version) -v q -nologo -o ..\$ReleaseFolder\$($Framework.Name)" -PassThru -WindowStyle Hidden).WaitForExit()
                (Start-Process -FilePath $CLI -ArgumentList "clean -f $($Framework.Version) -v q -nologo" -PassThru -WindowStyle Hidden).WaitForExit()
            }
        }
        Pop-Location

        if ($SigningCertificate)
        {
            if (Test-Path $ReleaseFolder)
            {
                Write-Host "Signing executable files" -ForegroundColor Yellow
                foreach ($File in (Get-ChildItem -Path $ReleaseFolder -Filter "*.exe" -Recurse | Select-Object FullName -ExpandProperty FullName))
                {
                    [void](Set-AuthenticodeSignature -FilePath $File -Certificate $SigningCertificate -TimestampServer $TimeStampServer -HashAlgorithm SHA256)
                }
            }
        }
    }
    else
    {
        Write-Warning -Message "The build files could could not be found.  Operation has been cancelled."
        break
    }
    
    Write-Host
    Write-Host "Process complete" -ForegroundColor Yellow
}