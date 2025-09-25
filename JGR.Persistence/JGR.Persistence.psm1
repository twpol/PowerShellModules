function Get-TempPersistence {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Name,
        [Parameter()][psobject]$Default = $null
    )
    $hash = [System.Security.Cryptography.SHA1Managed]::new() | ForEach-Object { $_.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Name)) } | ForEach-Object { $_.ToString("X2") } | Join-String -Separator ''
    $hashFile = "$env:TEMP\JGR.Persistence-$hash.txt"
    Write-Debug ('Get-TempPersistence: Name={0} File={1}' -f $Name, $hashFile)
    if (Test-Path -LiteralPath $hashFile) {
        Import-Clixml -LiteralPath $hashFile
        | Where-Object Name -EQ $Name
        | Where-Object Hash -EQ $hash
        | Select-Object -ExpandProperty Value
    }
    else {
        $Default
    }
}

function Set-TempPersistence {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][psobject]$Value
    )
    $hash = [System.Security.Cryptography.SHA1Managed]::new() | ForEach-Object { $_.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Name)) } | ForEach-Object { $_.ToString("X2") } | Join-String -Separator ''
    $hashFile = "$env:TEMP\JGR.Persistence-$hash.txt"
    Write-Debug ('Set-TempPersistence: Name={0} File={1}' -f $Name, $hashFile)

    [PSCustomObject]@{
        Name  = $Name
        Hash  = $hash
        Value = $Value
    }
    | Export-Clixml -LiteralPath $hashFile
}
