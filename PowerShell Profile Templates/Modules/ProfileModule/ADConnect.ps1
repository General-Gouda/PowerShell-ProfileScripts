#----------------------------------------------------#
# Run Production DirSync 
#----------------------------------------------------#
function Start-ProdAADCSync 
{

$splatting = @"
Import-Module ADSync;Start-ADSyncSyncCycle
"@

    $ScriptBlock = [Scriptblock]::Create($splatting)

	$time = Get-Date 
		
	$server = "DOMAINAPP100.DOMAIN.com"

    $UserCredential = Get-DecryptedPassword -EncryptedPassword $encryptedProdPassword -EncryptedKey $encryptedProdKey -Thumbprint $thumbPrint -AdminUsername "DOMAIN\username.admin"
    
    Invoke-Command -ComputerName $server -ScriptBlock $ScriptBlock -Credential $UserCredential

	$continue = $false
	$timer = 60

	do 
	{
		$eventLog = Get-EventLog -ComputerName $server -LogName Application -Source 'Directory Synchronization' -After $time -Newest 15

		$eventLog | ForEach-Object {
			if ($_.Message -match "Finished: Purging Run History") 
			{
				$continue = $true
			} 
		}

		$timer--
		Start-Sleep -Seconds 5
	} while ($continue -eq $false -and $timer -ge 1)

	if ($continue -eq $false) 
	{
			
		Write-Output "AADC Sync did not finish after 5 minutes. Please run AADC Sync manually."
		pause

	}
}

#----------------------------------------------------#
# Run Test DirSync 
#----------------------------------------------------#
function Start-TestAADCSync 
{
        
$splatting = @"
Import-Module ADSync;Start-ADSyncSyncCycle
"@

    $ScriptBlock = [Scriptblock]::Create($splatting)

	$time = Get-Date 
		
	$server = "DOMAINAPP500.TESTDOMAIN.local"

    $UserCredential = Get-DecryptedPassword -EncryptedPassword $encryptedTestPassword -EncryptedKey $encryptedTestKey -Thumbprint $thumbPrint -AdminUsername 'TESTDOMAIN\username'
    
    Invoke-Command -ComputerName $server -ScriptBlock $ScriptBlock -Credential $UserCredential

	$continue = $false
	$timer = 60

	do 
	{
		$eventLog = Get-EventLog -ComputerName $server -LogName Application -Source 'Directory Synchronization' -After $time -Newest 15

		$eventLog | ForEach-Object {
			if ($_.Message -match "Finished: Purging Run History") 
			{
				$continue = $true
			} 
		}

		$timer--
		Start-Sleep -Seconds 5
	} while ($continue -eq $false -and $timer -ge 1)

	if ($continue -eq $false) 
	{
			
		Write-Output "AADC Sync did not finish after 5 minutes. Please run AADC Sync manually."
		pause

	}
}


Export-ModuleMember -Function Start-ProdAADCSync, Start-TestAADCSync
