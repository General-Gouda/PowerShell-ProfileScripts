# Initialize new git repo in present location
function New-GitInit
{
	git init
	git add .
	git commit -m 'Initial Commit'
	git status
}

# Checks for updates in git repo and runs backups as necessary
function Test-GitBackups
{
	C:\Users\username\OneDrive\Computer_Stuff\PowerShell\git\Get-GitConfigBackup.ps1
}

# Creates new local git clone of a git repo. Prompts to create new git repo if one does not already exist.
function New-GitLocalClone
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory=$true)]
		$RepoToCloneLocation,

		[parameter(Mandatory=$true)]
		$Destination,

		[parameter(Mandatory=$false)]
		[switch]$NewDirectory,

		[parameter(Mandatory=$false)]
		[string]$DesiredBranch
	)
	
	if (Test-Path $Destination)
	{
		if (Test-Path $RepoToCloneLocation)
		{
			Push-Location $RepoToCloneLocation

			if ((git status) -notmatch "fatal")
			{
				if ($NewDirectory)
				{
					Push-Location $Destination
					git clone $RepoToCloneLocation
				}
				else
				{
					Push-Location $Destination
					git clone $RepoToCloneLocation $Destination
				}

				if ([string]::IsNullOrEmpty($DesiredBranch) -eq $false)
				{
					git checkout $DesiredBranch
				}
			}
			else
			{
				$continue = 0

				do
				{
					$query = Read-Host "Git repo not found at $RepoToCloneLocation`nInitialize new git repo here? [Y/N]"

					if ($query.ToUpper() -eq "Y")
					{
						New-GitInit
						Push-Location $Destination
						git clone $RepoToCloneLocation

						if ([string]::IsNullOrEmpty($DesiredBranch) -eq $false)
						{
							git checkout $DesiredBranch
						}
						$continue = 1
					}
					elseif ($query.ToUpper() -eq "N")
					{
						Write-Warning "No new git repo created. Stopping script."
						$continue = 1
					}
					else
					{
						Write-Output "Invalid input."
					}
				} while ($continue -eq 0)

			}
		}
		else
		{
			Write-Error "Folder location $RepoToCloneLocation not found!"
		}
	}
	else
	{
		Write-Error "Folder location $Destination not found!"
	}
}

# Creates new remote git clone of a git repo. Prompts to create new git repo if one does not already exist.
function New-GitRemoteClone
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory=$true)]
		$RepositoryUrl,

		[parameter(Mandatory=$true)]
		$Destination,

		[parameter(Mandatory=$false)]
		[switch]$NewDirectory,

		[parameter(Mandatory=$false)]
		[string]$DesiredBranch
	)
	
	if (Test-Path $Destination)
	{
		if ((git ls-remote $RepositoryUrl) -notmatch 'fatal')
		{
			if ($NewDirectory)
			{
				Push-Location $Destination
				git clone $RepositoryUrl
			}
			else
			{
				Push-Location $Destination
				git clone $RepositoryUrl $Destination
			}

			if ([string]::IsNullOrEmpty($DesiredBranch) -eq $false)
			{
				git checkout $DesiredBranch
			}
		}
		else
		{
			Write-Error "Remote repository not found!"
		}
	}
	else
	{
		Write-Error "Folder location $Destination not found!"
	}
}

Export-ModuleMember -Function New-GitInit,
							  Test-GitBackups,
							  New-GitLocalClone,
							  New-GitRemoteClone
