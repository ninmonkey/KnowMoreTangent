BeforeAll {
    Import-Module Pansies -ea 'stop'
    $source = $PSCommandPath -replace '\.tests\.ps1$', '.ps1' | Get-Item -ea 'Stop'
    . $Source
}
Describe 'Serialize.RgbColor' {
    BeforeAll {
        $SampleColorList = @(


        )
        # $o =
        # $o.Ordinals -as [int[]] | Join-String -op '#' -FormatString '{0:x}'

        #easier
        # $o.RGB | ForEach-Object ToSTring 'x'
    }
    It 'Color <Expected>' -ForEach @(
        @{
            ColorInstance = [PoshCode.Pansies.RgbColor]::FromRgb('#fe9231')
            Expected      = '#fe9231'
        }
    ) {
        # $ColorInstance | SerializeStr.From-RgbColor
        # $orange = [PoshCode.Pansies.RgbColor]::FromRgb('#fe9231')
        $ColorInstance
        | SerializeStr.RgbColor.From
        | Should -BeExactly $Expected
    }
}
