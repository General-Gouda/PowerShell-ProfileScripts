$Global:OD4BLocation = "C:\Users\username\Encrypted\OneDrive for Business"
$Global:ODPersonalLocation = "C:\Users\username\OneDrive\Computer_Stuff\PowerShell"

$Global:transcriptLocation = "$ODPersonalLocation\Transcripts\Cmd"

# Password and Thumbprint for new HP ZBook
$Global:encryptedProdPassword = ''
$Global:encryptedProdKey = ''

$Global:encryptedTestPassword = ''
$Global:encryptedTestKey = ''

$Global:thumbPrint = ''

#----------------------------------------------------#
# Execute Important Startup Apps
#----------------------------------------------------#
if (!(Get-Process app*))
{
    & "C:\Program Files (x86)\AppDev\AppName\AppName.exe"
}

#----------------------------------------------------#
# Transcript stuff
#----------------------------------------------------#
Start-Transcript -Path "$transcriptLocation\Transcript$(Get-Date -Format yyyy-MM-dd--hh-mmtt).txt" 

# Deletes transcripts older than 90 days
Get-ChildItem "$transcriptLocation\*.txt" | ForEach-Object {
    if (((Get-Date) - $_.LastWriteTime).Days -gt 30) {
        Remove-Item $_
    }
}

#----------------------------------------------------#
# Execute git backup system
#----------------------------------------------------#
& "C:\Users\username\OneDrive\Computer_Stuff\PowerShell\git\Get-GitConfigBackup.ps1"

#----------------------------------------------------#
# Modules to import at load up
#----------------------------------------------------#
Import-Module Posh-Git -Global
Import-Module ImportExcel -Global
Import-Module Microsoft.Xrm.Data.Powershell
Import-Module "$ODPersonalLocation\PowerShell Profile Templates\Modules\ProfileModule\Profile.psm1" -Global | Out-Null

#----------------------------------------------------#
# Time until Christmas
#----------------------------------------------------#
$tillChristmas = (Get-Date "December 25") - (Get-Date)
Write-Host ("{0} Days, {1} Hours, {2} Minutes, {3} seconds till December 25th! Christmas!!`n" -f $tillChristmas.Days, $tillChristmas.Hours, $tillChristmas.Minutes, $tillChristmas.Seconds)


#----------------------------------------------------#
# Execute Other Startup Apps
#----------------------------------------------------#
$processes = (Get-Process).ProcessName

if (!("SetPoint" -in $processes))
{
    & "C:\Program Files\Logitech\SetPointP\SetPoint.exe"
}

<# 
if (!("KeePass" -in $processes))
{
    & "C:\Users\username\OneDrive\Computer_Stuff\KeyPass\KeePass-2.34\KeePass.exe"
}
#>

if (!("Rainmeter" -in $processes))
{
    & "C:\Program Files\Rainmeter\Rainmeter.exe"
}

if (!("OneDrive" -in $processes))
{
    & "C:\Users\username\AppData\Local\Microsoft\OneDrive\OneDrive.exe" /background
}

if (!("googledrivesync" -in $processes))
{
    & "C:\Program Files (x86)\Google\Drive\googledrivesync.exe"
}

if (!("ShareX" -in $processes))
{
    & "C:\Program Files\ShareX\ShareX.exe"
}

#----------------------------------------------------#
# Global Prompt 
#----------------------------------------------------#
function Global:Prompt
{
    Write-Host ("{0}: " -f $MyInvocation.HistoryId) -NoNewline -ForegroundColor Gray
    Write-Host "[" -ForegroundColor Yellow -NoNewline
    Write-Host (Get-Date -Format T) -ForegroundColor Green -NoNewline
    Write-Host "]" -ForegroundColor Yellow -NoNewline
    Write-VcsStatus
    Write-Host " [" -ForegroundColor Yellow -NoNewline
    Write-Host (" {0} " -f $PWD) -ForegroundColor DarkGray -NoNewline
    Write-Host "]" -ForegroundColor Yellow

    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {
        Write-Host ">>_" -NoNewline -ForegroundColor Yellow
    }
    else
    {
        Write-Host ">_" -NoNewline -ForegroundColor Cyan
    }

    Return " "
}

#----------------------------------------------------#
# Set location to C:\
#----------------------------------------------------#
Set-Location C:\

