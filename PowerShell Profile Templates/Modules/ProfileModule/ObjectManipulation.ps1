function Import-JsonToObject
{
    [CmdletBinding()]
    param
    (
        [string]$FilePath
    )

    if (Test-Path $FilePath)
    {
        $fileInfo = (Get-Content -Path $FilePath) -join "`n" | ConvertFrom-Json
    }
    else
    {
        Throw "Path to JSON file not found."
    }

    return $fileInfo
}

function ConvertTo-JsonFile
{
    [CmdletBinding()]
    param
    (
        $InputObject,
        $FilePath,
        $FileName
    )

    $InputObject | ConvertTo-Json | Out-File "$FilePath\$FileName.json"
}


function Remove-NullValueProperties
{
    [CmdletBinding()]
    param
    (
        $InputObject
    )

    $InputObject | ForEach-Object {$settings = $_}

    return (Select-Object -InputObject $settings -Property (($InputObject.psobject.Properties | Where-Object {[string]::IsNullOrWhiteSpace($_.value) -eq $false}).Name))
}

Export-ModuleMember -Function Import-JsonToObject,
                              Remove-NullValueProperties,
                              ConvertTo-JsonFile