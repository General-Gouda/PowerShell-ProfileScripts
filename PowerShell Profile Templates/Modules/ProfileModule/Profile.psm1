<#
Personal Profile module
Created by: Matt Marchese
Version: 2016.12.05
#>

Push-Location -Path "$(Split-Path -Parent $MyInvocation.MyCommand.Path)"
Get-ChildItem -Path * -Include *.ps1 | foreach {. $_.FullName}

# Misc cmdlets

# Reload profile module
function Reset-ProfileModule
{
	$ODPersonalLocation = "C:\Users\username\OneDrive\Computer_Stuff\PowerShell\PowerShell Profile Templates"
	Import-Module "$ODPersonalLocation\Modules\ProfileModule\Profile.psm1" -Global -Force
}

# Creates a new ConEmu tab
Function New-ConEmu
{
	param
	(
		[switch]$Vertical,
		[switch]$Horizontal,
		[switch]$Admin,
		$Size
	)

	$conprefix = "-cur_console"
	$split = ""
	$asuffix = ""

	if ($Vertical)
	{
		$split = ":s"+$size+"V"
	}

	if ($Horizontal)
	{
		$split = ":s"+$size+"H"
	}
	
	if ($Admin)
	{
		$asuffix = ":a"
	}

	$output = $conprefix + $asuffix + $split
	ConEmu64.exe -reuse /cmd powershell $output
}

Pop-Location

Export-ModuleMember -Function Reset-ProfileModule, Stop-Proxy, Get-Proxy, New-ConEmu