# <%= $PLASTER_PARAM_Name %>
This repository contains all files required to build the **<%= $PLASTER_PARAM_Name %>** ScriptoForm project.  A *ScriptoForm* is a PowerShell script that generates and displays a [Microsoft Windows Forms](https://learn.microsoft.com/en-us/dotnet/desktop/winforms/overview/?view=netdesktop-8.0#introduction) application that can be used for a specific management or system administration task in a network environment.  A *ScriptoForm project* is the set of files and folders, including the PowerShell script, that can be compiled into an executable file using the Microsoft .NET CLI utility (dotnet.exe) which is available with any [Microsoft .NET SDK](https://dotnet.microsoft.com/en-us/download/dotnet).  Included in the repository is the Build.cs C# file which the compiler will use as the source for the executable, and the Build.csproj C# project file which provides the set of instructions used to compile the executable.

## Purpose
The **<%= $PLASTER_PARAM_Name %>** script launches a Windows form that provides a method to...*add additional information here...*

## Requirements
- This project supports the following command shells:
    - [Windows PowerShell 5.1](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-5.1)
    - [PowerShell 7.2.x](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.2)
    - [PowerShell 7.4.x](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.4)
- This project supports the following Microsoft .NET frameworks:
    - [Microsoft .NET 4.x](https://dotnet.microsoft.com/en-us/download/dotnet-framework)
    - [Microsoft .NET 6.x](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)
    - [Microsoft .NET 8.x](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)

## Compile Instructions
Perform the following prerequisite steps:
- Install the [Microsoft .NET 8.x SDK](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) on your development machine.
- Clone the repository to your development machine.

Use any of the below workflows to create an executable file of the PowerShell script that is compatible with the framework version specified:

Microsoft .NET 4.x Framework
- Open a supported command shell and navigate to the *Build* subdirectory in your local repository directory.
- Run the following command from within your *Build* subdirectory:<br>
``dotnet publish -f net48 -v q -nologo -o ..\Release\Legacy; dotnet clean -f net48 -v q -nologo``
- The compiled executable will be created in the *Release\Legacy* subdirectory of your local repository directory.  This location can be changed by modifying the ``-o`` parameter in the above command.
- The latest [Microsoft .NET 4.x Framework Runtime](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48) will be required on any computer used to run the executable.

Microsoft .NET 6.x Framework
- Open a supported command shell and navigate to the *Build* subdirectory in your local repository directory.
- Run the following command from within your *Build* subdirectory:<br>
``dotnet publish -f net6.0-windows -v q -nologo -o ..\Release\LTS-Legacy; dotnet clean -f net6.0-windows -v q -nologo``
- The compiled executable will be created in the *Release\LTS-Legacy* subdirectory of your local repository directory.  This location can be changed by modifying the ``-o`` parameter in the above command.
- The latest [Microsoft .NET 6.x Runtime](https://dotnet.microsoft.com/en-us/download/dotnet/6.0) will be required on any computer used to run the executable.

Microsoft .NET 8.x Framework
- Open a supported command shell and navigate to the *Build* subdirectory in your local repository directory.
- Run the following command from within your *Build* subdirectory:<br>
``dotnet publish -f net8.0-windows -v q -nologo -o ..\Release\LTS; dotnet clean -f net8.0-windows -v q -nologo``
- The compiled executable will be created in the *Release\LTS* subdirectory of your local repository directory.  This location can be changed by modifying the ``-o`` parameter in the above command.
- The latest [Microsoft .NET 8.x Runtime](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) will be required on any computer used to run the executable.

## Executable Notes
- When the executable file is run it will extract all resource files that were included in the compilation process to a unique temporary extraction directory in the user's profile directory.
- The executable will attempt to use the latest version of PowerShell discovered on the local machine to execute the extracted script file unless excluded by one of the command-line arguments noted below.  If a version of PowerShell is excluded by a command-line argument then the executable will attempt to use the next latest version of PowerShell discovered on the system.  The executable will always default to using Windows PowerShell if no other versions are available for use.
- After the PowerShell script execution has completed, all extracted files and the extraction directory are deleted and the executable terminates.
- The following optional command-line arguments can be used to control operation of the executable:
  | Argument          | Purpose                           | Notes                                                       |
  | ----------------- | --------------------------------- | ------------------------------------------------------------|
  | -Exclude:ALL      | Exclude PowerShell x.x.x versions | Do not use with other *Exclude* parameters                  |
  | -Exclude:PS7      | Exclude PowerShell 7.x.x versions | Do not use with other *Exclude* parameters                  |
  | -Debug            | Show console window               | Use individually or with one additional *Exclude* parameter |
