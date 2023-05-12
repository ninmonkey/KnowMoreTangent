'is this build, maybe, not get default'
@(
    $pcolor = '#{0}' -f @(GetColor -ColorLabel 'teal.bright')

    New-Lie -Name 'sma.CompletionRes' -TypeInfo ([System.Management.Automation.CompletionResult]) 6>&1
    New-Lie -Name 'sma.CompletionResType' -TypeInfo ([System.Management.Automation.CompletionResultType]) 6>&1
    New-Lie -Name 'List' -TypeInfo ([System.Collections.Generic.List`1]) 6>&1
    New-Lie -Name 'Rune' -TypeInfo ([Text.Rune]) 6>&1
    New-Lie -Name 'color.Rgb' -TypeInfo ([PoshCode.Pansies.RgbColor]) 6>&1
    New-Lie -Name 'color.Lab' -TypeInfo ([PoshCode.Pansies.HunterLabColor]) 6>&1
    New-Lie -Name color.space.Lab -TypeInfo ([PoshCode.Pansies.ColorSpaces.HunterLab]) 6>&1

    # New-Lie -Name text.Utf8 -TypeInfo ([System.Text.UTF8Encoding])   6>&1
    # New-Lie -Name text.Utf8 -TypeInfo ([System.Text.UTF8Encoding])   6>&1
    # New-Lie -Name 'encode.Info' -TypeInfo ([System.Text.EncodingInfo]) 6>&1
    # New-Lie -Name 'text.Encoding' -TypeInfo ([System.Text.Encoding]) 6>&1
)
| Join-String -op $PSStyle.Foreground.FromRgb('#' + (GetColor teal.bright)) -os $PSStyle.Reset -sep "`n"
# | Join-String -op $PSStyle.Foreground.FromRgb('#515c6b') -os $PSStyle.Reset