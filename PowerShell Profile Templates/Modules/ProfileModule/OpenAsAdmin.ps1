# Start new PowerShell ISE session as admin account
function Start-AdminISESession
{
    $credential = Get-DecryptedPassword -EncryptedPassword $encryptedProdPassword -EncryptedKey $encryptedProdKey -Thumbprint $thumbPrint -AdminUsername 'DOMAIN\username.admin'

    Start-Process "powershell_ise.exe" -Credential $credential
}

# Start new PowerShell console session as admin account
function Start-AdminPSSession
{
    $credential = Get-DecryptedPassword -EncryptedPassword $encryptedProdPassword -EncryptedKey $encryptedProdKey -Thumbprint $thumbPrint -AdminUsername 'DOMAIN\username.admin'

    Start-Process "powershell.exe" -Credential $credential
}

# Open a new Active Directory Users & Computers session as admin account
function Start-AdminADSession
{
	$credential = Get-DecryptedPassword -EncryptedPassword $encryptedProdPassword -EncryptedKey $encryptedProdKey -Thumbprint $thumbPrint -AdminUsername 'DOMAIN\username.admin'

	Start-Process "powershell.exe" -ArgumentList "mmc.exe dsa.msc" -Credential $credential -WindowStyle Hidden
}


Export-ModuleMember -Function Start-AdminISESession
Export-ModuleMember -Function Start-AdminPSSession
Export-ModuleMember -Function Start-AdminADSession
