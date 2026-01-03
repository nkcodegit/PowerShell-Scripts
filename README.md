PowerShell-Scripts 🛠️
A collection of useful PowerShell scripts for automation, system administration, and daily productivity. This repository serves as a centralized hub for scripts designed to simplify tasks on Windows and cross-platform environments.

📖 Table of Contents

About
Prerequisites
How to Use
Security Warning
License

🧐 About
This repository, maintained by nkcodegit, contains a variety of stand-alone PowerShell (.ps1) scripts. Whether you are looking to automate folder cleanup, fetch system reports, or manage Active Directory, these scripts are designed to be modular and easy to use.

⚙️ Prerequisites
Before running these scripts, ensure you have:

PowerShell 5.1 (Windows PowerShell) or PowerShell 7+ (Core) installed.

Execution Policy set to allow scripts. You can set this for your current session by running:
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

🚀 How to Use
1. Clone the Repository
   git clone https://github.com/nkcodegit/PowerShell-Scripts.git
   cd PowerShell-Scripts
   
3. Run a Script
Navigate to the directory containing the script and execute it:
   .\ScriptName.ps1 -ParameterName "Value"

⚠️ Security Warning
Always review scripts before running them. PowerShell scripts have the power to modify system settings, delete files, and change configurations.
Open the .ps1 file in VS Code or Notepad.
Understand what the code is doing.
Test in a non-production (lab) environment first.

