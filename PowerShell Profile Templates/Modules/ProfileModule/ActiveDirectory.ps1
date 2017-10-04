function Get-ADUserByName
{
    <#
    .SYNOPSIS
        Gets AD User information based on a user's Full name.
    .DESCRIPTION
        Gets AD User information based on a user's Full name.
    .PARAMETER Name
        Full first and last name of a user you want to find.
    .EXAMPLE
        Get-ADUserByName -Names "Joe Schmo" -Operator "eq" -Properties Name,SamAccountName,UserPrincipalName
    .NOTES
        Version 2017.05.15
        By Matt Marchese
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$Names,

        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateSet("eq","like")]
        [string]$Operator = "like",

        [Parameter(Mandatory = $false)]
        [string[]]$Properties = @("DistinguishedName","Enabled","GivenName","Name","ObjectClass","ObjectGUID","SamAccountName","SID","Surname","UserPrincipalName")
    )

    Import-Module ActiveDirectory

    foreach ($Name in $Names)
    {
        if ($Operator -eq "eq")
        {
            Get-ADUser -Filter {Name -eq $Name} -Properties $Properties | Select-Object $Properties
        }
        elseif ($Operator -eq "like")
        {
            Get-ADUser -Filter {Name -like $Name} -Properties $Properties | Select-Object $Properties
        }
    }
}

Export-ModuleMember -Function Get-ADUserByName