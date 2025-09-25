# PowerShellModules

## JGR.Data

- `Get-JsonFileItem [-JsonField] <string> [-JsonValue] <string> -LiteralPath <string[]> [-JsonPath <string[]>] [<CommonParameters>]`
- `Get-JsonFileItem [-Path] <string[]> [-JsonField] <string> [-JsonValue] <string> [-JsonPath <string[]>] [<CommonParameters>]`
- `Set-JsonFileItem [-JsonField] <string> [-JsonValue] <string> [[-JsonObject] <psobject>] -LiteralPath <string[]> [-JsonPath <string[]>] [<CommonParameters>]`
- `Set-JsonFileItem [-Path] <string[]> [-JsonField] <string> [-JsonValue] <string> [[-JsonObject] <psobject>] [-JsonPath <string[]>] [<CommonParameters>]`

## JGR.DateTime

- `Format-DateTime [[-DateTime] <datetime>] [[-Format] <string>] [<CommonParameters>]`

## JGR.Diagnostics

- `Get-CounterRawValue [-Set] <string> [-IdentificationCounterName] <string> [-IdentificationCounterValues] <string[]> [-CounterNames] <string[]> [<CommonParameters>]`

## JGR.Files

- `Get-ItemFromPath [[-LiteralPath] <string[]>] [[-Path] <string[]>] [[-InputObject] <psobject>] [<CommonParameters>]`

## JGR.Persistence

- `Get-TempPersistence [-Name] <string> [[-Default] <psobject>] [<CommonParameters>]`
- `Set-TempPersistence [-Name] <string> [-Value] <psobject> [<CommonParameters>]`
