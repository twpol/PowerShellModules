$source = Split-Path -Parent $PSCommandPath
$readme = "$source/README.md"

Get-ChildItem -LiteralPath $source -Directory | Import-Module -Verbose

$modules = Get-Module | Where-Object { $_.Path -like "$source*" }

@(
    '# PowerShellModules'
    ''
    $modules | ForEach-Object {
        '## {0}' -f $_.Name
        ''
        $_.ExportedFunctions.Values | ForEach-Object {
            $f = $_
            $_.ParameterSets | ForEach-Object {
                '- `{0} {1}`' -f $f.Name, $_.ToString()
            }
        }
    }
)
| Out-File $readme

$modules | Remove-Module -Verbose
