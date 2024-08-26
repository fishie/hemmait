Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile WinGet.msixbundle
Add-AppxPackage WinGet.msixbundle
Remove-Item WinGet.msixbundle
winget source update

winget add Microsoft.PowerShell --accept-source-agreements
winget add zyedidia.micro --accept-source-agreements
winget add 7zip.7zip --accept-source-agreements
winget add Google.GoogleDrive --accept-source-agreements
winget add DominikReichl.KeePass --accept-source-agreements
winget add emoacht.Monitorian --accept-source-agreements
winget add Brave.Brave --accept-source-agreements
winget add Mozilla.Firefox --accept-source-agreements
winget add Valve.Steam --accept-source-agreements
winget add clsid2.mpc-hc --accept-source-agreements
winget add AutoHotkey.AutoHotkey --accept-source-agreements
winget add SomePythonThings.WingetUIStore --accept-source-agreements
