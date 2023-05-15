Import-Module Pansies -ea 'stop' # Assert-ImportedPansies

<#
$tinfo.ImplementedInterfaces.fullname

    [PoshCode.Pansies.ColorSpaces.IColorSpace]
    [PoshCode.Pansies.ColorSpaces.IRgb]
    [IEquatable[PoshCode.Pansies.RgbColor]]

$tinfo.PsTypeNames

    [PoshCode.Pansies.RgbColor]
    [PoshCode.Pansies.ColorSpaces.Rgb]
    [PoshCode.Pansies.ColorSpaces.ColorSpace]
    [Object]


original
    $o = [PoshCode.Pansies.RgbColor]'#fe9231'
    $o.Ordinals -as [int[]] | Join-String -op '#' -FormatString '{0:x}'

    #easier
    $o.RGB | % ToSTring 'x'

#>
function SerializeStr.RgbColor.From {
    [Alias(
        'SerializeStr.From-RgbColor',
        '.Serialize.From-RgbColor'
        # 'SerializeStr.To-RgbColor',
        # 'SerializeStr.RgbColor.From',
        # 'SerializeStr.RgbColor.To',
    )]
    [CmdletBinding()]
    param(
        [Alias('Color', 'RgbColor')]
        [OutputType('System.String')]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        $InputObject
    )
    process {
        # assert
        if ( [string]::IsNullOrWhiteSpace($InputObject) ) { return }
        $InputObject.RGB | Join-String -f '#{0:x}'
    }
}

