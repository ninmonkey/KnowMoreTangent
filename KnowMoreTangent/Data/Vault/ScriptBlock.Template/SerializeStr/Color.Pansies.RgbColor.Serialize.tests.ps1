BeforeAll {
    Import-Module Pansies -ea 'stop'
    $source = $PSCommandPath -replace '\.tests\.ps1$', '.ps1' | Get-Item -ea 'Stop'
    . $Source
}
Describe 'Serialize.RgbColor' {
    BeforeAll {
        $SampleColorList = @(

            @{
                ColorInstance = [PoshCode.Pansies.RgbColor]::FromRgb('#fe9231')
                Expected      = '#fe9231'
            }
        )
        # $o =
        # $o.Ordinals -as [int[]] | Join-String -op '#' -FormatString '{0:x}'

        #easier
        # $o.RGB | ForEach-Object ToSTring 'x'
    }
    It 'Color <Expected>' -ForEach @( $SampleColorList ) {
        # $ColorInstance | SerializeStr.From-RgbColor
        if ($null -eq $ColorInstance) {
            throw 'ColorShouldNeverBeNullIfPassedCorrectly'
        }
        $ColorInstance | SerializeStr.RgbColor.From
        | Should -BeExactly $Expected
    }
}
