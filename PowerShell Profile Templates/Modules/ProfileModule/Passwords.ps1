function Get-RandomPassword
{
    Param
    (
        [int]$PasswordLength=16,
        [switch]$Secure
    )
    
    $ascii = $NULL;For ($a=48;$a -le 122;$a++) {$ascii+=,[char][byte]$a}

    For ($loop=1; $loop -le $PasswordLength; $loop++)
    {
        $randomPassword += ($ascii | Get-Random)
    }

    if ($Secure)
    {
        $randomPassword = ConvertTo-SecureString $randomPassword -AsPlainText -Force
    }

    return $randomPassword
}

Function New-ComplexPassword {
    
    [Cmdletbinding(DefaultParameterSetName='Single')]
        Param(
        [Parameter(ParameterSetName='Single')]
        [Parameter(ParameterSetName='Multiple')]
        [Int]
        $PasswordLength,
        
        [Parameter(ParameterSetName='Single')]
        [Parameter(ParameterSetName='Multiple')]
        [int]
        $SpecialCharCount,

        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ParameterSetName='Multiple')]
        [String[]]
        $GenerateUserPW
        )
    Begin {   
        # The System.Web namespaces contain types that enable browser/server communication
        Add-Type -AssemblyName System.Web 
    }
    Process {
        switch ($PsCmdlet.ParameterSetName) {
            'Single' {
                # GeneratePassword static method: Generates a random password of the specified length
                [System.Web.Security.Membership]::GeneratePassword($PasswordLength, $SpecialCharCount)
            }
            'Multiple' {
                $GenerateUserPW | Foreach {
                    # Custom Object to display results
                    New-Object -TypeName PSObject -Property @{
                        User = $_
                        Password = [System.Web.Security.Membership]::GeneratePassword($PasswordLength, $SpecialCharCount)
                   }
                }
            }
        } # End of Switch
    }
} # End of Function

function New-DOMAINRandomPassword
{
    [CmdletBinding()]
    param
    (
        [int]$NumberOfWordsInPassword = 3,
        [int]$PasswordLength = 16,
        [switch]$NumbersAtTheEnd
    )

    if ($NumbersAtTheEnd)
    {
        $PasswordLength = $PasswordLength - 3
    }

    if (($PasswordLength / $NumberOfWordsInPassword) -lt 4)
    {
        Throw "Impossible calculation.`nToo many words requested in password for length to mathematically handle.`nPlease decrease the number of words or increase the password length."    
    }
    else
    {
        Push-Location $PSScriptRoot

        $words = Get-Content ..\..\Files\wordlist.txt

        [string]$password = $null
        $numArray = @()
        $total = 0
            
        do
        {
            $total = 0
            $numArray = @()
        
            1..$NumberOfWordsInPassword | ForEach-Object {
                $numArray += Get-Random -Minimum 4 -Maximum $PasswordLength
            }
        
            foreach ($num in $numArray)
            {
                $total += $num
            }
        } until ($total -eq $PasswordLength)

        foreach ($number in $numArray)
        {
            if ($number -ne $lastNum)
            {
                $wordArray = New-Object System.Collections.ArrayList
            
                foreach ($word in $words)
                {
                    if ($word.Length -eq $number)
                    {
                        $wordArray.add($word) | Out-Null
                    }
                }
            }
        
            $randomWord = $wordArray | Get-Random
        
            $password += (Get-Culture).TextInfo.ToTitleCase($randomWord)
        }
        
        if ($NumbersAtTheEnd)
        {
            $password += (100..999 | Get-Random -Count 1)
        }

        Pop-Location

        return $password
    }
}

Export-ModuleMember -Function Get-RandomPassword, New-ComplexPassword, New-DOMAINRandomPassword