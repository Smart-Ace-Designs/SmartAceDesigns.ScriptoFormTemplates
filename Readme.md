# ScriptoForm Templates Module
This module contains a [PowerShell Plaster](https://www.powershellgallery.com/packages/Plaster) template and deployment functions that can be used to create a starter ScriptoForm project.

## Purpose
A *ScriptoForm* is a PowerShell script that generates and displays a [Microsoft Windows Forms](https://learn.microsoft.com/en-us/dotnet/desktop/winforms/overview/?view=netdesktop-8.0#introduction) application that can be used for a specific management or system administration task in a network environment.  Typically, this script is compiled into an executable file which hides the PowerShell console window during execution and provides a more seamless and familiar experience to the user.  A *ScriptoForm project* is the set of files and folders, including the PowerShell script, that can be used to compile the script into an executable file.

The template folder within this module contains a PlasterManifest.xml file which provides the instructions used by Plaster to generate the new ScriptoForm project folders and files.  Once deployed, additional code should be added to the PowerShell script to provide the custom functionality of the ScriptoForm.

The script and optional support files that you add to a project created from the template can be compiled into an executable using the Microsoft .NET CLI utility (dotnet.exe) which is available with any [Microsoft .NET SDK](https://dotnet.microsoft.com/en-us/download/dotnet).  Included in the template and deployed into your project is a Build.cs C# file which the compiler will use as the source for the executable, and a Build.csproj C# project file which provides the set of instructions used to compile the executable.

The PowerShell script and any additional support files will be embedded into the executable as resources at compile time.

## Requirements
- This project supports the following command shells:
    - [Windows PowerShell 5.1](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-5.1)
    - [PowerShell 7.2.x](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.2)
    - [PowerShell 7.3.x](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.3)
    - [PowerShell 7.4.x](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.4)
- This project requires the following PowerShell modules: 
    - [Plaster 1.1.4](https://www.powershellgallery.com/packages/Plaster)

## Template Files
The following files within the template folder of this module are used by Plaster to generate the files within the new ScriptoForm project folder:
- Build\Build.cs
- Build\Build.csproj
- .gitignore
- Readme.md
- Script.ps1

## Template Deployment Instructions
- Deploy the required PowerShell Plaster module to a registered PowerShell modules directory on your Windows development machine.
- Deploy this module to a registered PowerShell modules directory on your Windows development machine.
- Use PowerShell to run the ``New-SADScriptoFormProject`` function and create a new ScriptoForm project.  Provide appropriate parameters to the function as required for your project.  For specific instructions use: ``Get-Help New-SADScriptoFormProject -Full``
- Customize the new project files that were created from the deployment using the customization guidelines below.

https://github.com/Smart-Ace-Designs/SmartAceDesigns.ScriptoFormTemplates/assets/132539186/21b636b0-9b66-4013-87ee-22988cde02c5

## Customization Guidelines
Follow these guidelines to customize the files in the new ScriptoForm project folder after deployment:
- [Script File] Add general notes to the top comments section.
- [Script File] Add global settings, constants, and support file references to the *Settings* region and remove the temporary reminder comments.
- [Script File] Add additional form controls to the *Controls* region and remove the temporary reminder comments.
- [Script File] Add control properties and handlers in the *$ShowMainForm* script block for any new controls you added and remove the temporary reminder comments.
- [Script File] Add custom functions to the *Functions* region and remove the temporary reminder comments; remove the *Functions* region if unused.
- [Script File] Add additional control event handler definitions to the *Handlers* region for any new controls you added and remove the temporary reminder comments.
- [Script File] Add script functionality, exception handling, and control reset code in the *$ButtonRun_Click* script block and remove the temporary reminder comments.
- [Readme File] Add content to the *Purpose* region.
- [Project Folder] Add additional support files referenced by the PowerShell script to the folder.
- [CSPROJ File] Add an `<EmbeddedResource>` sub-element, for each support file referenced by the PowerShell script, to the `<ItemGroup>` element.
- [Build Folder] Add a custom icon file to the folder if the default icon is unsuitable.
- [CSPROJ File] Add the custom icon filename to the `<ApplicationIcon>` element if the default icon is unsuitable.
