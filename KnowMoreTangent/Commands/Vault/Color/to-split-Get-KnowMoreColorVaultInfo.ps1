

function __normalize.HexString {
    <#
    .SYNOPSIS
    [normalizeString pattern] normalize hexstrings to always include a hash prefix

    .EXAMPLE
    PS>
    '#345', '###324', '123'
        | __normalize.HexString
        | Should -beExactly @('#345', '#324', '#123' )
    .NOTES
        currently doesn't care how many digits, or which characters are involved
        future:

    validateMustMatchOneRegex:
        '#?[\da-fA-F]{6}',
        '#?[\da-fA-F]{8}'
        '#?[\da-fA-F]{2,3}' # css allows:


    #>
    param(
        [Alias('Text', 'Hex', 'HexColor')]
        [Parameter(Mandatory, Position = 0)]
        [string]$InputHexString
    )
    process {
        $InputHexString -replace '^#+', '' | Join-String -op '#'
    }
}


function __saveColor__renderColorName {
    <#
    .synopsis
        [renderSpecialType pattern] Ansi Colors to render HexColors using hex strings
    #>
    [Alias('.fmt.color.renderHexName')]
    [CmdletBinding()]
    param(
        [Parameter()]
        $Name = 'noName',

        [Parameter(Mandatory)]
        $HexColor
    )
    $cleanStr = $HexColor -replace '^#', ''
    if ($cleanStr.Length -notin @(6, 8)) {
        throw "Unexpected color, expects 6/8 digits: '$HexColor'"
    }
    $HexStr = '#{0}' -f @(
        $cleanStr
    )

    $renderColorPair = @{
        OutputPrefix = $PSStyle.Foreground.FromRgb($HexStr)
        OutputSuffix = $PSStyle.Reset
    }

    '{0} = #{1}' -f @(
        $Name
        $HexColor
    ) | Join-String @renderColorPair
    # | Write-Information -infa 'continue'
}
function GetColor {
    <#
    .SYNOPSIS
        [collection pattern] saved colors

    .EXAMPLE
        # Renders color values
        PS> GetColor -ListAll

            blue = ##234991
            blue.dim = #3c77d3
            green.dim = #73b254
            dark.teal = #2a5153
            Name = ##73b254
            5 items
    .EXAMPLE
        # as exportable json
        PS> GetColor -Json

        {   "blue":      "#234991",
            "blue.dim":  "3c77d3",
            "green.dim": "73b254",
            "dark.teal": "2a5153",
            "Name":      "#73b254" }
    #>
    [CmdletBinding(DefaultParameterSetName = 'GetColor')]
    param(
        # autocomplete known colors
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 0 , parameterSetName = 'GetColor')]
        [string]$ColorLabel,

        [Parameter(Mandatory, parameterSetName = 'ListOnly')]
        [switch]$ListAll,
        [switch]$Loose,

        [Parameter(parameterSetName = 'JsonOnly')]
        [switch]$Json
    )


    $script:__newColorState ??= @{}
    $state = $script:__newColorState

    switch ($PSCmdlet.ParameterSetName) {
        'JsonOnly' {
            if ($Json) {
                return $State | ConvertTo-Json -Depth 2
            }
        }
        'ListOnly' {
            $state.Keys | Join-String -sep ', '
            | Join-String -op ($state.keys.count | Join-String -f 'Colors: {0} = ')
            | Write-Verbose

            $state.GetEnumerator()
            | CountOf 6>&1 # optional
            | ForEach-Object {
                '{0} => {1}' -f @(
                    $_.key
                    $_.Value
                )
            } | Join-String -sep "`n" | Write-Verbose

            $state.GEtEnumerator()
            | CountOf
            | ForEach-Object {
                __saveColor__renderColorName -Name $_.key -HexColor $_.Value
            }
            return
        }
        default { }
    }
    if ($State.ContainsKey($ColorLabel)) {
        return $state[$ColorLabel]
    }
    else {
        if (-not $Loose) {
            # else soft error, try partial match, if  match is exactly one then use it.
            throw ('Color not found! Expected: {0}' -f @(
                    $state.keys -join ', '
                ))
        }
        # 'loose'
        $key? = $State.Keys -match $ColorLabel | Select-Object -First 1
        if ($Key?) {
            return $state[ $Key? ]
        }

    }
    throw 'Failed to find loose color keys'

}

function __validate.HexString {
    <#
    .SYNOPSIS
        assert a string is as close to a valid hex str with variations
    .EXAMPLE
    PS>
        '2141j14', '222323', '#12341234', '#12345'
            | __validate.HexString
            | Should -BeExactly @($false, $true, $true, $false)
    #>
    [Alias(
        '__assert.valid.HexString',
        'HexString.ParseExact'
    )]
    [CmdletBinding()]
    param(
        [Alias('HexString')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        $InputText
    )
    begin {
        $Config = @{
            AllowedLengths = 6, 8 # 2, 3
            AlwaysAssert   = $false
        }
        if ($PSCmdlet.MyInvocation.MyCommand.Name -match 'assert') {
            $Config.AlwaysAssert = $True
        }
    }
    process {



        $Raw = $InputText
        $WithoutHash = $Raw -replace '#', ''
        $Regex = @{
            AllowedWord   = '^#?[\d+a-fA-F]+$'
            AllowedDigits = '^[\d+a-fA-F]+$'
        }
        $ValidLength = $WithoutHash.Length -in @(6, 8)
        $cases = @(
            $ValidLength
            $Raw -match $Regex.AllowedWord
            $WithoutHash -match $Regex.AllowedDigits
            $WithoutHash -match $Regex.AllowedWord
        )
        $anyFalse = (@($cases) -eq $false).count -gt 0

        if ($Config.AlwaysAssert) {
            throw ('AssertIsValidHexString: Failed! "{0}"' -f @(
                    $InputText
                ))
        }
        return -not $AnyFalse
    }
}

function SaveColor {
    <#
    .SYNOPSIS
    [collection pattern] Named color aliases, persists across sessions

    .EXAMPLE
    PS> SaveColor -Name 'orange.dark3' -HexColor '352b1e'
    PS> SaveColor -Name 'blue.dim' '3c77d3'

    .NOTES
    Default file location:

        Join-Path $Env:Nin_Dotfiles 'store/saved_colors.json'


    related, see also:
        __saveColor__renderColorName
        __normalize.HexString
        SaveColor
        GetColor
        ImportColor
    #>
    [Alias('NewColor')]
    [CmdletBinding()]
    param(
        [Alias('Color', 'ColorName', 'Label')]
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 0)]
        [string]$HexColor,

        [switch]$Strict

    )
    $Config = @{
        AlwaysSaveOnAssign = $false
    }
    $script:__newColorState ??= @{}
    $state = $script:__newColorState

    $cleanStr = $HexColor -replace '^#+', '#' # just one
    $cleanStr = $HexColor -replace '^#+', '#' # or none
    $cleanStr = __normalize.HexString -HexColor $HexColor
    $cleanDigits = $cleanStr -replace '#+', ''
    if ($cleanDigits.Length -notin @(6, 8)) {
        # Wait-Debugger
        Write-Error "Unexpected color, expects 6/8 digits: '$HexColor'"
        return
    }
    $HexStr = '{0}' -f @(
        $cleanDigits
    )
    if ($State.ContainsKey($Name)) {
        if ($State[$Name] -ne $HexStr) {
            #no change, no error
            __saveColor__renderColorName -Name $Name -HexColor $HexColor
            | Join-String -op 'Different Color AlreadyExists!'
            | Write-Verbose
            # | Write-Verbose -Verbose
            if ($Strict) {
                # or the inverse, using force?
                throw 'Different color already exists'
            }
        }
        else {
            __saveColor__renderColorName -Name $Name -HexColor $HexColor
            | Join-String -op 'Same Color Already Saved. '
            | Write-Verbose #-Verbose
        }
    }

    $state[ $Name  ] = $HexStr

    __saveColor__renderColorName -Name $Name -HexColor $HexColor
    | Join-String -op 'Saved '
    | Write-Information #-infa 'Continue'

    # 'save colors'
    if ($Config.AlwaysSaveOnAssign) {
        GetColor -Json
        | ConvertFrom-Json -AsHashtable
        | Ninmonkey.Console\Sort-Hashtable -SortBy Key
        | ConvertTo-Json -Depth 2
        | Set-Content -Path (Join-Path $Env:Nin_Dotfiles 'store' 'saved_colors.json')
    }


    # 'saved: {0} = {1}' -f @(
    #     $Name
    #     $HexColor
    # ) | Join-String -op $PSStyle.Foreground.FromRgb($HexStr) -os $PSStyle.Reset
    # | Write-Information -infa 'continue'
}
function SaveModule {
    <#
    .SYNOPSIS
    [collection pattern] Named Module aliases, persists across sessions

    .EXAMPLE
    PS> SaveModule -Name 'orange.dark3' -HexModule '352b1e'
    PS> SaveModule -Name 'blue.dim' '3c77d3'

    .NOTES

    Default file location:

        Join-Path $Env:Nin_Dotfiles 'store/saved_Modules.json'


    related, see also:
        __saveModule__renderModuleName
        __normalize.HexString
        SaveModule
        GetModule
        ImportModule
    #>
    [Alias('nin.SaveModule')]
    [CmdletBinding()]
    param(
        [Alias('Module', 'ModuleName')]
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [string]$Name
    )
    $Config = @{
        AlwaysSaveOnAssign = $false
    }
    $script:__newModuleState ??= @{}
    $state = $script:__newModuleState

    $hexModule
    if ($State.ContainsKey($Name)) {
        if ($State[$Name] -ne $HexStr) {
            #no change, no error
            __saveModule__renderModuleName -Name $Name -HexModule $HexModule
            | Join-String -op 'Different Module AlreadyExists!'
            | Write-Verbose
            # | Write-Verbose -Verbose
            if ($Strict) {
                # or the inverse, using force?
                throw 'Different Module already exists'
            }
        }
        else {
            __saveModule__renderModuleName -Name $Name -HexModule $HexModule
            | Join-String -op 'Same Module Already Saved. '
            | Write-Verbose #-Verbose
        }
    }

    $state[ $Name  ] = $HexStr

    __saveModule__renderModuleName -Name $Name -HexModule $HexModule
    | Join-String -op 'Saved '
    | Write-Information #-infa 'Continue'

    # 'save Modules'
    if ($Config.AlwaysSaveOnAssign) {
        GetModule -Json
        | ConvertFrom-Json -AsHashtable
        | Ninmonkey.Console\Sort-Hashtable -SortBy Key
        | ConvertTo-Json -Depth 2
        | Set-Content -Path (Join-Path $Env:Nin_Dotfiles 'store' 'saved_modules.json')
    }


    # 'saved: {0} = {1}' -f @(
    #     $Name
    #     $HexModule
    # ) | Join-String -op $PSStyle.Foreground.FromRgb($HexStr) -os $PSStyle.Reset
    # | Write-Information -infa 'continue'
}

@(

) | Out-Null

<#
generate a bunch of grays
#>
# & {
#     # generate defaults
#     0..100
#     | Where-Object { $_ % 5 -eq 0 }
#     | ForEach-Object {
#         $percent = $_
#         $Key = 'Gray.{0}' -f @( $percent )

#         $mod = $percent / 100
#         $component = 255 * $Mod -as 'int' | ForEach-Object tostring 'x'
#         $renderHex = '#{0}{0}{0}' -f @( $Component )
#     }


# }
& { #function __generate.Colors.Gray {
    param(
        [ValidateRange(0, 99)]
        [int]$min = 0,

        [ValidateRange(1, 100)]
        [int]$max = 100,

        [ValidateRange(1, 99)]
        [int]$StepSize = 5
    )
    $min..$Max # 0..100
    | Where-Object { $_ % $StepSize -eq 0 }
    | ForEach-Object {
        $percent = $_
        $Key = 'Gray.{0:d2}' -f @( $percent )

        $mod = $percent / 100
        $component = 255 * $Mod -as 'int' | ForEach-Object tostring 'x2'
        $renderHex = '#{0}{0}{0}' -f @( $Component )
        '{0} => {1} ' -f @( $key, $renderHex )
        SaveColor -Name $Key -HexColor $RenderHex
        | Out-Null
    }
} *>&1 | Out-Null


# SaveColor -Name 'blue' '234991'
# SaveColor -Name 'blue.dim' '3c77d3'
# SaveColor -Name 'green.dim' '73b254'
# SaveColor -Name 'dark.teal' '2a5153'
# SaveColor -Name 'green' '73b254'



function ImportColor {
    <#
    .SYNOPSIS
        bulk load man colors
    #>
    [CmdletBinding()]
    param(

        [switch]$ClearCurrent,
        [switch]$ListAll
    )
    $script:__newColorState ??= @{}
    $state = $script:__newColorState

    $Path
    | Join-String -f 'ImportingFrom: {0}'
    | Write-Verbose

    if ($ClearCurrent) {
        $state.clear()
    }

    $Path = Join-Path $Env:Nin_Dotfiles 'store' 'saved_colors.json'
    $jsonConfig? = Get-Item -ea 'ignore' $Path
    if (-not $jsonConfig?) {
        throw ($Path | Join-String -f 'No saved colors at {0}!')
    }

    # $json = Get-Content -Path $JsonConfig?
    # $json | ConvertFrom-Json
    # | ForEach-Object {
    #     SaveColor -Name $_.Name -HexColor $_.HexColor
    # }
    Get-Content -Path $jsonConfig? | ConvertFrom-Json -AsHashtable | ForEach-Object GetEnumerator | ForEach-Object {
        SaveColor -Name $_.key -HexColor $_.Value
    }

    $colorsHash = Get-Content -Path $jsonConfig? | ConvertFrom-Json -AsHashtable
    $state = $colorsHash

    if ($ListAll) {
        GetColor -ListAll
    }
    $state.keys.count | Join-String -f 'Imported {0} colors' | Write-Information -infa 'continue'
}

[Collections.Generic.List[Object]]$script:__xlr8rLog ??= @()

function New-Lie {
    <#
    .SYNOPSIS
        TypeInfo lies, type accelerator , lies.
    .EXAMPLE
        Get-Lie
    .EXAMPLE
        Get-Lie | Sort-Object TypeName
        | fw -Column 1 TypeName
    .NOTES

    .LINK
        New-Lie
    .LINK
        Get-Lie
    #>
    param(
        #New alias
        [Parameter(Mandatory, Position = 0)]$Name,
        # TypeInfo instance
        [Parameter(Mandatory, Position = 1)]$TypeInfo
    )

    # throw ('Lie alreads exists! {0} => {1}' -f @(
    #         $Name
    #         ($Name -as 'type')
    #     ))

    class LieRecord {
        [string]$Name
        [string]$ShortType
        [string]$Namespace
        hidden [string]$TypeName
        hidden [object]$TypeInfo # instance of type info.
        # can a resolved type ever fail in this usage?

        LieRecord (
            [string]$Name,
            # [string]$TypeName,
            [object]$TypeInfo
        ) {
            $this.Name = $Name
            $this.ShortType = $TypeInfo.Name
            $this.TypeInfo = $TypeInfo
            $this.TypeName = $TypeInfo.ToString()
            $this.Namespace = $TypeInfo -split '\.' | Select-Object -SkipLast 1 | Join-String -sep '.'
        }
    }

    '{0} isType: {1}, asType: {2}' -f @(
        $TypeInfo
        $TypeInfo -is 'type'
        $TypeInfo -as 'type'
        # ) | Write-Information #-infa 'continue'
    ) | Write-Verbose #-infa 'continue'

    # $script:xlr8r ??= [psobject].assembly.gettype('System.Management.Automation.TypeAccelerators')
    $script:xlr8r::Add($Name, $TypeInfo)

    # $isNew = ($script:__xlr8rLog | Where-Object { $_.Name -match $Name }).count -gt 0
    # if ($IsNew) {
    if (-not ($script:__xlr8rLog.Name -contains $Name)) {
        $script:__xlr8rLog.Add(
            [LieRecord]::New(
                ($Name),
                ($TypeInfo)
                # ($TypeInfo -as 'type')
            )
        )
    }

    'New Lie: {0} => {1}' -f @(
        $Name
        $TypeInfo
    ) | Write-Information #-infa 'continue'
}


function Get-Lie {
    <#
    .SYNOPSIS
        List already created lies -- TypeInfo lies, type accelerator , lies.
    .EXAMPLE
        Get-Lie
    .EXAMPLE
        Get-Lie
            | ft Name, TypeInfo -GroupBy Namespace
    .EXAMPLE
        Get-Lie
            | Sort-Object Name, Namespace, TypeInfo
            | ft Name, TypeInfo, Namespace

        Get-Lie
            | Sort-Object Name, Namespace
            | ft Name, Namespace
    .description
        show lies. (or, at least the user's lies).
    .LINK
        New-Lie
    .LINK
        Get-Lie
    #>
    param()
    $script:__xlr8rLog | Sort-Object TypeName, Name
}


# $xlr8r::Add( 'Lie', ([System.Collections.Generic.IList`1]) )
# New-Lie -name 'Lie' -TypeInfo [System.Collections.Generic.iList`1]
# New-Lie -name 'Lie' -TypeInfo [System.Collections.Generic.List`1]