function Get-ItemFromPath {
    [CmdletBinding()]
    param (
        [Parameter()][string[]]$LiteralPath,
        [Parameter()][string[]]$Path,
        [Parameter()][psobject]$InputObject
    )
    process {
        if ($InputObject.PSPath -and $InputObject.PSProvider) {
            Write-Debug "Get-ItemFromPath: Has InputObject ($($InputObject.GetType().FullName)): $InputObject"
        }
        if ($LiteralPath) {
            Write-Debug "Get-ItemFromPath: Has LiteralPath ($($LiteralPath.GetType().FullName)): $LiteralPath"
        }
        if ($Path) {
            Write-Debug "Get-ItemFromPath: Has Path ($($Path.GetType().FullName)): $Path"
        }

        if ($InputObject.PSPath -and $InputObject.PSProvider) {
            Write-Debug "Get-ItemFromPath: Using InputObject"
            $InputObject
        }
        elseif ($LiteralPath) {
            Write-Debug "Get-ItemFromPath: Using LiteralPath"
            Resolve-Path -LiteralPath $LiteralPath -ErrorAction Stop | ForEach-Object { Get-Item -LiteralPath $_ -ErrorAction Stop }
        }
        elseif ($Path) {
            Write-Debug "Get-ItemFromPath: Using Path"
            Resolve-Path -Path $Path -ErrorAction Stop | ForEach-Object { Get-Item -LiteralPath $_ -ErrorAction Stop }
        }
    }
}
