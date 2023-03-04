#HEY! LISTEN! Do this first, 'Set-ExecutionPolicy -ExecutionPolicy Unrestricted'

#Run this WSL script as admin!
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
shutdown /r /f /t 0