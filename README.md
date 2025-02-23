# ScriptoForm Template Module Repository
This repository contains the source code for the [SmartAceDesigns.ScriptoFormTemplates](https://www.powershellgallery.com/packages/SmartAceDesigns.ScriptoFormTemplates) PowerShell module hosted in the PowerShell Gallery. The module contains a [PowerShell Plaster](https://www.powershellgallery.com/packages/Plaster) template and PowerShell function that can be used to create a new **ScriptoForm Project** as well as a PowerShell function that can be used to compile a **ScriptoForm** into an executable file.

https://github.com/Smart-Ace-Designs/SmartAceDesigns.ScriptoFormTemplates/assets/132539186/6a72ddef-d11d-444f-b7c2-7e0657f6cdb4

## ScriptoForm Overview
A **ScriptoForm** is a PowerShell script that generates and displays a [Microsoft Windows Forms](https://learn.microsoft.com/en-us/dotnet/desktop/winforms/overview/?view=netdesktop-9.0#introduction) application that can be used to automate the management of a computer network environment. Typically, this script is compiled into an executable file which hides the PowerShell console window during execution and provides a more seamless and familiar experience to the user. A **ScriptoForm Project** is the set of files and folders, including the PowerShell script, that can be used to compile the script into an executable file.

The template folder within this module contains a PlasterManifest.xml file which provides the instructions used by Plaster to generate the new **ScriptoForm Project** folders and files. Once deployed, additional code is then added to the PowerShell script by a **ScriptoForm** developer to add controls to the form and provide custom functionality.

The script and optional support files that you add to a project created from the template can be compiled into an executable using the Microsoft .NET CLI utility (dotnet.exe) which is available with any [Microsoft .NET SDK](https://dotnet.microsoft.com/en-us/download/dotnet). Included in the template and deployed into your project is a Build.cs C# file which the compiler will use as the source for the executable, and a Build.csproj C# project file which provides the set of instructions used to compile the executable. The PowerShell script and any additional support files will be embedded into the executable as resources at compile time.

## Additional Information
For information on how to deploy and customize a new **ScriptoForm** please visit the official [ScriptoForm Docs](https://smartacedesigns-scriptoform-docs.netlify.app/) site.

