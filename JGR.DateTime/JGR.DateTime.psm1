function Format-DateTime {
    [CmdletBinding()]
    param (
        [Parameter()][datetime]$DateTime,
        [Parameter()][string]$Format = 'HH:mm'
    )

    $rollover = $env:JGR_DAY_ROLLOVER ?? 0
    Write-Debug ('Format-DateTime: DateTime={0} Format={1} Rollover={2}' -f $DateTime, $Format, $rollover)
    if ($Format -cmatch 'hh?') {
        Write-Warning ('Format-DateTime: Skipping rollover for format with 12-hour time component: {0}' -f $Format)
        $DateTime.ToString($Format)
    }
    else {
        $hour24_1 = '{0:D1}' -f ($DateTime.Hour -lt $rollover ? $DateTime.Hour + 24 : $DateTime.Hour)
        $hour24_2 = '{0:D2}' -f ($DateTime.Hour -lt $rollover ? $DateTime.Hour + 24 : $DateTime.Hour)
        $formatInput = $Format -creplace 'HH?', '''[$0]'''
        $formatOutput = $DateTime.AddHours(-$rollover).ToString($formatInput)
        Write-Debug ('Format-DateTime: FormatInput={0} FormatOutput={1}' -f $formatInput, $formatOutput)
        $formatOutput -creplace '\[H\]', $hour24_1 -creplace '\[HH\]', $hour24_2
    }
}
