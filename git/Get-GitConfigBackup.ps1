git config --global user.name "My Name"
git config --global user.email myemail@gmail.com

$backupObjects = [PSCustomObject] @{
    MineCraftPE = @{
        Name = "MC-PE"
        OriginalLocation = "C:\Users\username\AppData\Local\Packages\Microsoft.MinecraftUWP_UID\LocalState\games\com.mojang\minecraftWorlds"
        BackupLocation = "C:\Users\username\OneDrive\Computer_Stuff\Game Stuff\MineCraftPE\Windows 10\minecraftWorlds"
    }

    MineCraft = @{
        Name = "MC"
        OriginalLocation = "C:\Users\username\AppData\Roaming\.minecraft\saves"
        BackupLocation = "C:\Users\username\OneDrive\Computer_Stuff\Game Stuff\MineCraft\saves"
    }

    LOTRO = @{
        Name = "LOTRO"
        OriginalLocation = "C:\Users\username\Documents\The Lord of the Rings Online"
        BackupLocation = "C:\Users\username\OneDrive\Computer_Stuff\Game Stuff\The Lord of the Rings Online"
    }

    Shortcuts = @{
        Name = "Shortcuts"
        OriginalLocation = "C:\Users\username\Shortcuts"
        BackupLocation = "C:\Users\username\OneDrive\Computer_Stuff\Shortcuts"
    }

    VSCodeSettings = @{
        Name = "Visual Studio Code Settings"
        OriginalLocation = "C:\Users\username\AppData\Roaming\Code\User"
        BackupLocation = "C:\Users\username\OneDrive\Computer_Stuff\Visual Studio Code\User"
    }
}

$backupObjects | Get-Member -MemberType NoteProperty | ForEach-Object {
    $backup = $_.Name

    $backupName = $backupObjects.$backup.Name
    $originalLocation = $backupObjects.$backup.OriginalLocation
    $backupLocation = $backupObjects.$backup.BackupLocation

    if (Test-Path $originalLocation)
    {
        Set-Location $originalLocation
        if ((git status) -match "Untracked files:|Changes to be committed:|deleted:|Changes not staged for commit:")
        {
            Write-Host "Changes found for $backupName" -ForegroundColor Yellow
            git add .
            git commit -m "Update $(Get-Date)"

            if (Test-Path $backupLocation) {
                Set-Location $backupLocation
                git pull
            }
            else
            {
                Write-Error "Backup Location for $backupName not found in $backupLocation!"
            }
        }
        else
        {
            Write-Host "Nothing to commit to $backupName, working directory clean" -ForegroundColor Green
        }
    }
    else
    {
        Write-Error "Original Location for $backupName not found in $originalLocation!"
    }
}

Push-Location C:\

