#----------------------------------------------------#
# Connect to Office 365 Production Tenant
#----------------------------------------------------#
function Connect-DOMAINProdOffice365Tenant 
{
    function Connect-ToSessions
    {
        Import-Module msonline
        $cred = Get-DecryptedPassword -EncryptedPassword $encryptedProdPassword -EncryptedKey $encryptedProdKey -Thumbprint $thumbPrint -AdminUsername 'username.admin@DOMAIN.com'
        $o365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $cred -Authentication Basic -AllowRedirection -Name 'Office365Prod'
        $skypeSession = New-CsOnlineSession -Credential $cred    
        Connect-MsolService -Credential $cred
        Connect-AzureAD -Credential $cred
        Import-Module (Import-PSSession $o365Session -AllowClobber -DisableNameChecking) -Global | Out-Null
        Import-Module (Import-PSSession $skypeSession -AllowClobber -DisableNameChecking) -Global | Out-Null
    }

    if ((Get-PSSession).Name -eq $null)
    {
        Connect-ToSessions
    }
    elseif ((Get-PSSession).Name -ne $null -and "Office365Prod" -notin (Get-PSSession).Name)
    {
        Close-Connections
        Connect-ToSessions
    }
    elseif ("Office365Prod" -in (Get-PSSession).Name)
    {
        Write-Output "Connection to Office365Prod already established."
    }
}

#----------------------------------------------------#
# Connect to Office 365 Production Tenant Compliance
#----------------------------------------------------#
function Connect-DOMAINProdOffice365TenantCompliance 
{
    function Connect-ToSessions
    {
        Import-Module msonline
        $cred = Get-DecryptedPassword -EncryptedPassword $encryptedProdPassword -EncryptedKey $encryptedProdKey -Thumbprint $thumbPrint -AdminUsername 'username.admin@DOMAIN.com'
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.compliance.protection.outlook.com/powershell-liveid/" -Credential $cred -Authentication Basic -AllowRedirection -Name 'Office365ProdCompliance'
        Connect-MsolService -Credential $cred
        Import-Module (Import-PSSession $Session -AllowClobber -DisableNameChecking) -Global | Out-Null
    }

    if ((Get-PSSession).Name -eq $null)
    {
        Connect-ToSessions
    }
    elseif ((Get-PSSession).Name -ne $null -and "Office365ProdCompliance" -notin (Get-PSSession).Name)
    {
        Close-Connections
        Connect-ToSessions
    }
    elseif ("Office365ProdCompliance" -in (Get-PSSession).Name)
    {
        Write-Output "Connection to Office365ProdCompliance already established."
    }
}

#----------------------------------------------------#
# Connect to Office 365 Dev Test Tenant
#----------------------------------------------------#
function Connect-TESTDOMAINOffice365Tenant 
{
    function Connect-ToSessions
    {
        Import-Module msonline
        $cred = Get-DecryptedPassword -EncryptedPassword $encryptedTestPassword -EncryptedKey $encryptedTestKey -Thumbprint $thumbPrint -AdminUsername 'username@TESTDOMAIN.com'
        $o365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $cred -Authentication Basic -AllowRedirection -Name 'Office365Test'
        $skypeSession = New-CsOnlineSession -Credential $cred    
        Connect-MsolService -Credential $cred
        Connect-AzureAD -Credential $cred
        Import-Module (Import-PSSession $o365Session -AllowClobber -DisableNameChecking) -Global | Out-Null
        Import-Module (Import-PSSession $skypeSession -AllowClobber -DisableNameChecking) -Global | Out-Null
    }

    if ((Get-PSSession).Name -eq $null)
    {
        Connect-ToSessions
    }
    elseif ((Get-PSSession).Name -ne $null -and "Office365Test" -notin (Get-PSSession).Name)
    {
        Close-Connections
        Connect-ToSessions
    }
    elseif ("Office365Test" -in (Get-PSSession).Name)
    {
        Write-Output "Connection to Office365Test already established."
    }
}

#----------------------------------------------------#
# Connect to Exchange 2013 Production on premise 
#----------------------------------------------------#
function Connect-DOMAINProdOnPrem2013 
{
    function Connect-ToSessions
    {
        $UserCredential = Get-DecryptedPassword -EncryptedPassword $encryptedProdPassword -EncryptedKey $encryptedProdKey -Thumbprint $thumbPrint -AdminUsername 'DOMAIN\username.admin'
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://DOMAINMAIL100.DOMAIN.com/PowerShell/" -Authentication Kerberos -Credential $UserCredential -Name "ExchangeOnPremProd"
        Import-Module (Import-PSSession $Session -AllowClobber -DisableNameChecking) -Global | Out-Null
    }

    if ((Get-PSSession).Name -eq $null)
    {
        Connect-ToSessions
    }
    elseif ((Get-PSSession).Name -ne $null -and "ExchangeOnPremProd" -notin (Get-PSSession).Name)
    {
        Close-Connections
        Connect-ToSessions
    }
    elseif ("ExchangeOnPremProd" -in (Get-PSSession).Name)
    {
        Write-Output "Connection to ExchangeOnPremProd already established."
    }
}

#----------------------------------------------------#
# Connect to Exchange 2013 Dev Test on premise 
#----------------------------------------------------#
function Connect-TESTDOMAINOnPrem2013 
{
    function Connect-ToSessions
    {
        $UserCredential = Get-DecryptedPassword -EncryptedPassword $encryptedTestPassword -EncryptedKey $encryptedTestKey -Thumbprint $thumbPrint -AdminUsername 'TESTDOMAIN\username'
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://DOMAINMAIL500.TESTDOMAIN.local/PowerShell/" -Authentication Kerberos -Credential $UserCredential -Name "ExchangeOnPremTest"
        Import-Module (Import-PSSession $Session -AllowClobber -DisableNameChecking) -Global | Out-Null
    }

    if ((Get-PSSession).Name -eq $null)
    {
        Connect-ToSessions
    }
    elseif ((Get-PSSession).Name -ne $null -and "ExchangeOnPremTest" -notin (Get-PSSession).Name)
    {
        Close-Connections
        Connect-ToSessions
    }
    elseif ("ExchangeOnPremTest" -in (Get-PSSession).Name)
    {
        Write-Output "Connection to ExchangeOnPremTest already established."
    }
}

#----------------------------------------------------#
# Connect to Skype for Business Online Production
#----------------------------------------------------#
function Connect-DOMAINSkypeForBusinessOnlineProd 
{
    Import-Module LyncOnlineConnector
    $UserCredential = Get-DecryptedPassword -EncryptedPassword $encryptedProdPassword -EncryptedKey $encryptedProdKey -Thumbprint $thumbPrint -AdminUsername 'username.admin@DOMAIN.com'
    $skypeSession = New-CsOnlineSession -Credential $UserCredential    
    Import-Module (Import-PSSession $skypeSession -AllowClobber -DisableNameChecking) -Global | Out-Null
}

#----------------------------------------------------#
# Connect to Skype for Business Online Dev Test
#----------------------------------------------------#
function Connect-DOMAINSkypeForBusinessOnlineTest 
{
    Import-Module LyncOnlineConnector
    $UserCredential = Get-DecryptedPassword -EncryptedPassword $encryptedTestPassword -EncryptedKey $encryptedTestKey -Thumbprint $thumbPrint -AdminUsername 'username@TESTDOMAIN.com'
    $skypeSession = New-CsOnlineSession -Credential $UserCredential    
    Import-Module (Import-PSSession $skypeSession -AllowClobber -DisableNameChecking) -Global | Out-Null
}

function Connect-DOMAINCrmDevTesting
{
    Import-Module Microsoft.Xrm.Data.Powershell
    $UserCredential = Get-DecryptedPassword -EncryptedPassword $encryptedProdPassword -EncryptedKey $encryptedProdKey -Thumbprint $thumbPrint -AdminUsername 'username.admin@DOMAIN.com'
    $connectionInfo = Connect-CrmOnline -Credential $UserCredential -ServerUrl 'https://TESTDOMAIN.crm.dynamics.com/'
    Write-Output ("Is Ready XRM Connection to 'https://TESTDOMAIN.crm.dynamics.com/' listed as {0}" -f $connectionInfo.IsReady)
}

# Runs Get-PSSession which is harder to type than Get-Connections
function Get-Connections
{
    Get-PSSession
}

# Close all PSSession connections
function Close-Connections
{
    Get-PSSession | Remove-PSSession
    Disconnect-AzureAD
}

Export-ModuleMember -Function Connect-DOMAINProdOffice365Tenant,
                              Connect-DOMAINProdOffice365TenantCompliance,
                              Connect-TESTDOMAINOffice365Tenant,
                              Connect-DOMAINProdOnPrem2013,
                              Connect-TESTDOMAINOnPrem2013,
                              Connect-DOMAINSkypeForBusinessOnlineProd,
                              Connect-DOMAINSkypeForBusinessOnlineTest,
                              Connect-DOMAINCrmDevTesting,
                              Get-Connections,
                              Close-Connections
