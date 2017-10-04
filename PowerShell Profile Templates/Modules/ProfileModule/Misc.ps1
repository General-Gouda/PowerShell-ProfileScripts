function New-VoiceOutput
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position = 0)]
        [string]$TextInput,

        [Parameter(Mandatory=$false, Position = 1)]
        [ValidateRange(-10,10)]
        [int]$Rate = 0
    )

    Add-Type -AssemblyName System.Speech

    $talk = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $talk.Rate = $Rate

    $talk.Speak($TextInput)
}

function Send-PushMessage
{
    <#
    .Synopsis
    Use this Function to use the pushbullet service to send push messages to your browser, computer or device 
    .DESCRIPTION
    *****To use this function, you must register for a PushBullet account and copy your API key from under 'Account Settings'
        
    *****As of this release (Halloween Day, 2014) Lists and File Upload support are not yet functional
        
    Use this Function as a stand-alone push service, or embed within your other functions to perform dynamic messaging as needed
    
        
    .EXAMPLE
    Send-PushMessage -msg "Hello world" -title "Mandatory first message text" 
    
    #You will receive a push message on all of your configured devices with a "Hello World" message
        
    .EXAMPLE
    get-winevent -LogName System | Select -first 1500 | ? Id -eq '1074' | % {Send-PushMessage -Title "Reboot detected on System" -Message ("Reboot detected on " + $_.MachineName + "@ " +  $_.TimeCreated) -Type Message}
    
    
    #In this more complex scenario, if an event of 1074 (System Reboot) is noted within the most recent 1500 events, send a message using PushBullet with information from the event.  
    .NOTES
        If this function halts with a Warning message of "Please place your API Key within line 48 and try again", be certain to provide your API key on line 48.
    #>
    
    [CmdletBinding(DefaultParameterSetName = 'Message')]
    param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "File")]$FileName,
        [Parameter(Mandatory = $true, ParameterSetName = "File")]$FileType,
        [Parameter(Mandatory = $true, ParameterSetName = "File")]
        [Parameter(Mandatory = $true, ParameterSetName = "Link")]$URL,
         
        [Parameter(Mandatory = $false, ParameterSetName = "Address")]$PlaceName,
        [Parameter(Mandatory = $true, ParameterSetName = "Address")]$PlaceAddress,
 
        [Parameter(Mandatory = $false)]
        [ValidateSet("Address", "Message", "File", "List", "Link")]
        [Alias("Content")] 
        $Type,
         
        [switch]$UploadFile,
        [string[]]$Items,
        $Title = "PushBullet Message",
        $Message
    )

    begin
    {
        $encryptedStringInfo = @{
            EncryptedString = '76492d1116743f0423413b16050a5345MgB8ADYAQwBzACsAMQBnAGQARQA3AFYAOABmAGkAYQBlAFgASgBYAG8AdABpAEEAPQA9AHwAZAAxADQAMgA4ADAAYwA5AGIAZQA0ADcANQA4ADUAYgBjADUAOQBkAGMAZgBjADUANQA4ADYANAAxADcAMQA5AGYAZAAyADQAZABjADgAMwBlADkAZAAyADEAZAA4AGIANAA3ADMAOAA3AGEAOABmADEANQA0AGMAYgAwADAANAAxADQAYgA3AGMAMQA0ADQAZgBiADcAMQAwADQAMQAzADUANABlADIANQA3ADEAMQAwADkAOABlADUANAA1ADkANwA1AGIAMAA2ADQAOQA0ADAAOQBhAGEAOQA2AGMAYgBhADcAYgA2ADgANwAwADAAOQA0AGUAMQBlAGEANQA3ADgAOQBjAGYANgBiADQAYgBjADgAMgA0ADcAMQAzADYAZgAxAGUAYQBmADIANQA2AGIAZAA3ADIAZABlAGIAOAA='
            EncryptedKey = 'e70zSKZXygnyLjPtAAUqVJyld9sC4j+82Bt89Nz7CEXz1YJCrWQeHafOyfFRuLwmJj7SGD/c2RcnFalYM0s66U32yFAhQ+w5G/0+gUaaJnpwmmsmuEcq5CSlV2W4vfhTzJhpBB2nSs1PXm37wpG9giw/Guxe/OAYUJedT+ol28NvwSwSAtBnMdyVWo5LdCMcQqBGYpczNl3+UUN8TW6TXUfldbj4uzo/h+w1Lkm8WndlsBAoREYjEb9ezl+QT97qaST774xUG+guW/OfVz21Jq7jWBI1Y0FQaGZn8DpMwJV9H7uFFS0ZEWiKLZE4WfXwLmVyfjIHmM+uS+hPiwG3CQ=='
            Thumbprint = '77661EC727925D705F5A36C8CA2A777779E9E385'
        }

        $api = Get-EncryptedString @encryptedStringInfo
        $PushURL = "https://api.pushbullet.com/v2/pushes"
        $devices = "https://api.pushbullet.com/v2/devices"
        $uploadRequestURL = "https://api.pushbullet.com/v2/upload-request"
        $uploads = "https://s3.amazonaws.com/pushbullet-uploads"
 
        $cred = New-Object System.Management.Automation.PSCredential ($api, (ConvertTo-SecureString $api -AsPlainText -Force))
 
        if (($PlaceName) -or ($PlaceAddress)) {$type = "address"}
 
        if ($api -eq "***YourAPIHere***")
        {
            Write-warning "Please place your API Key within line 48 and try again"
            BREAK
        }
    }
 
    process
    {
        switch ($Type)
        {
            'Address'
            {
                Write-Verbose "Sending an Address"<#SendaMessagestuff#>
                $body = @{
                    type    = "address"
                    title   = $Placename
                    address = $PlaceAddress
                }
            }
            'Message'
            {
                Write-Verbose "Sending a message"<#SendaMessagestuff#>
                $body = @{
                    type  = "note"
                    title = $title
                    body  = $msg
                }
            }
            'List'
            {
                Write-Verbose "Sending a list "<#SendaListstuff#>
                $body = @{
                    type  = "list"
                    title = $title
                    items = $items
                     
                } 
                     
                "body preview"
                $body
                #$body = $body | ConvertTo-Json 
            }
            'Link'
            {
                Write-Verbose "Sending a link "<#SendaLinkstuff#>
                $body = @{
                    type  = "link"
                    title = $title
                    body  = $msg
                    url   = $url
                } 
 
            }
            'File'
            {
                Write-Verbose "Sending a file "<#SendaFilestuff#>
                 
                if ($UploadFile)
                {  
                    $UploadRequest = @{
                        file_name = $FileName
                        fileType  = $FileType
                    }
         
                    #Ref: Pushing files https://docs.pushbullet.com/v2/pushes/#pushing-files
                    # "Once the file has been uploaded, set the file_name, file_url, and file_type returned in the response to the upload request as the parameters for a new push with type=file."
             
                    #Create Upload request first
                    $attempt = Invoke-WebRequest -Uri $uploadRequestURL -Credential $cred -Method Post -Body $UploadRequest -ErrorAction SilentlyContinue
                    if ($attempt.StatusCode -eq "200")
                    {
                        Write-Verbose "Upload Request OK"
                    }
                    else
                    {
                        Write-Warning "error encountered, check `$Uploadattempt for more info"
                        $global:Uploadattempt = $attempt
                    }
 
                    #Have to include the data field from the full response in order to begin an upload
                    $UploadApproval = $attempt.Content | ConvertFrom-Json | select -ExpandProperty data 
         
                    #Have to append the file data to the Upload request        
                    $UploadApproval | Add-Member -Name "file" -MemberType NoteProperty -Value ([System.IO.File]::ReadAllBytes((get-item C:\TEMP\upload.txt).FullName))
 
                    #Upload the file and get back the url
                    #$UploadAttempt = 
                    #Invoke-WebRequest -Uri $uploads -Credential $cred -Method Post -Body $UploadApproval -ErrorAction SilentlyContinue
                    #Doesn't work...maybe invoke-restMethod is the way to go?
             
                    Invoke-WebRequest -Uri $uploads -Method Post -Body $UploadApproval -ErrorAction SilentlyContinue
                    #End Of Upload File scriptblock
                }
                Else
                {
                    #If we don't need to upload the file
                 
                    $body = @{
                        type      = "file"
                        file_name = $fileName
                        file_type = $filetype
                        file_url  = $url
                        body      = $msg
                    } 
                 
                }
                $global:UploadApproval = $UploadApproval
                BREAK
                #End of File switch
 
            }
            #End of Switch Statement
        }
 
        write-debug "Test-value of `$body before it gets passed to Invoke-WebRequest"
 
        $Sendattempt = Invoke-WebRequest -Uri $PushURL -Credential $cred -Method Post -Body $body -ErrorAction SilentlyContinue
 
        if ($Sendattempt.StatusCode -eq "200")
        {
            Write-Verbose "OK"
        }
        else
        {
            Write-Warning "Error encountered, check `$attempt for more info"
            $global:Sendattempt = $Sendattempt  
        }
    }
 
    end
    {
        $global:Sendattempt = $Sendattempt
    }
}

function Select-Value
{
    [Cmdletbinding()]
    Param
    (
        [parameter(Mandatory=$true)] [String] $Value,
        [parameter(ValueFromPipeline=$true)] $InputObject
    )

    Process
    {
        # Identify the PropertyName for respective matching Value, in order to populate it Default Properties
        $Property = ($PSItem.properties.Where({$_.Value -Like "$Value"})).Name

        if ($Property)
        {
            # Create Property a set which includes the 'DefaultPropertySet' and Property for the respective 'Value' matched
            $DefaultPropertySet = $PSItem.PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames 
            $TypeName = ($PSItem.PSTypenames)[0]
            Get-TypeData $TypeName | Remove-TypeData
            Update-TypeData -TypeName $TypeName -DefaultDisplayPropertySet ($DefaultPropertySet + $Property | Select-Object -Unique)
            
            # Output Objects
            $PSItem | Where-Object {$_.Properties.Value -like "$Value"}
        }
    }
}

function Add-CSharpType
{
    [CmdletBinding()]
    param
    (
        [string[]]$Assemblies,
        [string]$Source
    )

    if ([string]::IsNullOrWhiteSpace($Assemblies))
    {
        Add-Type -TypeDefinition $Source -Language CSharp
    }
    else
    {
        Add-Type -ReferencedAssemblies $Assemblies -TypeDefinition $Source -Language CSharp
    }
}

Export-ModuleMember -Function New-VoiceOutput, Send-PushMessage, Select-Value, Add-CSharpType