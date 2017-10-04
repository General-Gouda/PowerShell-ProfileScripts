# Map new drive letter
function New-MappedDrive
{
	[CmdletBinding()]
	param
	(
		[parameter(Position=0)][string]$DriveLetter,
		[parameter(Position=1)][string]$Destination,
		[switch]$Persistent
	)

	if ($DriveLetter -notcontains ":")
	{
		$DriveLetter = $DriveLetter + ":"
	}

	$Destination = $Destination.TrimEnd("\")

	if ($Persistent)
	{
		& net use $DriveLetter $Destination /Persistent:Yes
	}
	else
	{
		& net use $DriveLetter $Destination
	}

	while ((Test-Path "$DriveLetter\") -eq $false) {
		Start-Sleep -Seconds 1
	}
	
	Set-Location "$DriveLetter\"
}

# Remove a mapped drive
function Remove-MappedDrive
{
	[CmdletBinding()]
	param
	(
		[parameter(Position=0)][string]$DriveLetter
	)

	if ($DriveLetter -notcontains ":")
	{
		$DriveLetter = $DriveLetter + ":"
	}

	if ((Get-Location).Path -like "$DriveLetter\")
	{
		Set-Location C:\
	}

	net use $DriveLetter /Delete
}

Export-ModuleMember -Function New-MappedDrive,
							  Remove-MappedDrive
