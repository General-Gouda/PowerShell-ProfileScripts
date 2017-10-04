$Global:OD4BLocation = "C:\Users\username\Encrypted\OneDrive for Business"
$Global:ODPersonalLocation = "C:\Users\username\OneDrive\Computer_Stuff\PowerShell"

$Global:transcriptLocation = "$ODPersonalLocation\Transcripts\VSCode"

# Password and Thumbprint for new HP ZBook
$Global:encryptedProdPassword = ''
$Global:encryptedProdKey = ''

$Global:encryptedTestPassword = ''
$Global:encryptedTestKey = ''

$Global:thumbPrint = ''

Start-Transcript -Path "$transcriptLocation\Transcript$(Get-Date -Format yyyy-MM-dd--hh-mmtt).txt" 

Get-ChildItem "$transcriptLocation\*.txt" | ForEach-Object {
    if (((Get-Date) - $_.LastWriteTime).Days -gt 30) {
        Remove-Item $_
    }
}

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

