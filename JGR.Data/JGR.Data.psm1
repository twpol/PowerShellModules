function Get-JsonFileItem {
    [CmdletBinding(PositionalBinding = $false)]
    param (
        [Parameter(ParameterSetName = "LiteralPath", Mandatory, ValueFromPipelineByPropertyName)][Alias("PSPath", "LP")][string[]]$LiteralPath,
        [Parameter(ParameterSetName = "Path", Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)][string[]]$Path,
        [Parameter()][string[]]$JsonPath = @(),
        [Parameter(Mandatory, Position = 1)][string]$JsonField,
        [Parameter(Mandatory, Position = 2)][string]$JsonValue
    )
    process {
        Get-ItemFromPath -LiteralPath $LiteralPath -Path $Path -InputObject $_ | ForEach-Object {
            Write-Debug ('Get-JsonFileItem: Path={0} JsonPath={1} JsonField={2} JsonValue={3}' -f $_.FullName, ($JsonPath -join '.'), $JsonField, $JsonValue)
            $json = Get-Content $_ | ConvertFrom-Json -Depth 10
            # Navigate to where array of items is
            foreach ($jsonPathSegment in $JsonPath) {
                $json = $json.$jsonPathSegment
            }
            if (-not $json.GetType().IsArray) {
                throw ('Get-JsonFileItem: Expected array; got {0}' -f $json.GetType().FullName)
            }
            # Find specific item in array
            $json | Where-Object $JsonField -CEQ $JsonValue
        }
    }
}

function Set-JsonFileItem {
    [CmdletBinding(PositionalBinding = $false)]
    param (
        [Parameter(ParameterSetName = "LiteralPath", Mandatory, ValueFromPipelineByPropertyName)][Alias("PSPath", "LP")][string[]]$LiteralPath,
        [Parameter(ParameterSetName = "Path", Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)][string[]]$Path,
        [Parameter()][string[]]$JsonPath = @(),
        [Parameter(Mandatory, Position = 1)][string]$JsonField,
        [Parameter(Mandatory, Position = 2)][string]$JsonValue,
        [Parameter(Position = 3)][psobject]$JsonObject
    )
    process {
        Get-ItemFromPath -LiteralPath $LiteralPath -Path $Path -InputObject $_ | ForEach-Object {
            # Convert hashtable into PSObject (makes calling this function much simpler)
            if ($JsonObject -is [hashtable]) {
                $JsonObject = new-object psobject -Property $JsonObject
            }
            Write-Debug ('Set-JsonFileItem: Path={0} JsonPath={1} JsonField={2} JsonValue={3} JsonObject={4}' -f $_.FullName, ($JsonPath -join '.'), $JsonField, $JsonValue, $JsonObject)
            if ($JsonObject -and $JsonObject.$JsonField -cne $JsonValue) {
                throw ('Set-JsonFileItem: Invalid JSON object: Expected {0}={1}; got {0}={2}' -f $JsonField, $JsonValue, $JsonObject[$JsonField])
            }
            $json = $jsonBase = Get-Content $_ | ConvertFrom-Json -Depth 10
            # Navigate to where array of items is
            foreach ($jsonPathSegment in $JsonPath) {
                $json = $json.$jsonPathSegment
            }
            if (-not $json.GetType().IsArray) {
                throw ('Get-JsonFileItem: Expected array; got {0}' -f $json.GetType().FullName)
            }
            # Find specific item in array
            $jsonItem = $json | Where-Object $JsonField -CEQ $JsonValue
            if ($JsonObject -and $jsonItem) {
                # Update
                $json = $json | ForEach-Object { $_ -ceq $jsonItem ? $JsonObject : $_ }
            }
            elseif ($JsonObject) {
                # Append
                $json += $JsonObject
            }
            else {
                # Delete
                $json = $json | Where-Object $JsonField -CNE $JsonValue
            }
            # Update JSON with new array of items
            $jsonPart = $jsonBase
            for ($i = 0; $i -lt $JsonPath.Count - 1; $i++) {
                $jsonPart = $jsonPart.($jsonPath[$i])
            }
            if ($JsonPath.Count -gt 0) {
                $jsonPart.($jsonPath[-1]) = $json
                $jsonBase | ConvertTo-Json -Depth 10 | Out-File $_
            }
            else {
                $json | ConvertTo-Json -Depth 10 | Out-File $_
            }
        }
    }
}
