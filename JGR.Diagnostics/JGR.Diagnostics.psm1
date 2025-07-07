function Get-CounterRawValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Set,

        [Parameter(Mandatory = $true)]
        [string]
        $IdentificationCounterName,

        [Parameter(Mandatory = $true)]
        [string[]]
        $IdentificationCounterValues,

        [Parameter(Mandatory = $true)]
        [string[]]
        $CounterNames
    )

    $data = [System.Diagnostics.PerformanceCounterCategory]::new($Set).ReadCategory()

    foreach ($IdentificationCounterValue in $IdentificationCounterValues) {
        $index = @($data[$IdentificationCounterName].Values | ForEach-Object { [string]$_.RawValue }).IndexOf($IdentificationCounterValue)
        $props = [ordered]@{}
        @($IdentificationCounterName) + $CounterNames | ForEach-Object {
            if ($index -ge 0 -and $data.Contains($_)) {
                $value = $data[$_].Values | Select-Object -Index $index
                if ($value.Sample.CounterType -eq [System.Diagnostics.PerformanceCounterType]::Timer100Ns) {
                    $props.$_ = $value.RawValue / 10000
                }
                else {
                    $props.$_ = $value.RawValue
                }
            }
            else {
                $null 
            }
        }
        [PSCustomObject]$props
    }
}
