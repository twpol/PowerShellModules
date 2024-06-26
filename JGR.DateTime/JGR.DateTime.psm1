function Format-DateTime {
    [CmdletBinding()]
    param (
        [Parameter()]
        [datetime]
        $DateTime,

        [Parameter()]
        [string]
        $Format = 'HH:mm'
    )

    $rollover = $env:JGR_DAY_ROLLOVER ?? 0
    Write-Debug ('Format-DateTime: DateTime={0} Format={1} Rollover={2}' -f $DateTime, $Format, $rollover)
    $hour12 = $DateTime.ToString('hh')
    $hour24 = '{0:D2}' -f ($(if ($DateTime.Hour -lt $rollover) { $DateTime.Hour + 24 } else { $DateTime.Hour }))
    $DateTime.AddHours(-$rollover).ToString(($Format -creplace 'hh', '''[hh]''' -creplace 'HH', '''[HH]''')) -creplace '\[hh\]', $hour12 -creplace '\[HH\]', $hour24
}
