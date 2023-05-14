function Template-CollectFromPipeline {
    <#
    .SYNOPSIS
        .
    .Description
        .
    .NOTES
        .
    .EXAMPLE
        Pwsh🐒> Gci

    #>
    # [Alias('TemplateAlias')]
    [OutputType('System.Object[]', 'PSObject')]
    [CmdletBinding()]
    param(
        # ...
        # [Alias('Object')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        # Expose additional settings, ie: it's **kwargs
        [ArgumentCompletions(
            '@{ SomeSetting = "blank" }'
        )]
        [Alias('Kwargs')]
        [Parameter()][hashtable]$Options = @{}
    )
    begin {
        $Config = Ninmonkey.Console\Join-Hashtable -OtherHash $Options -BaseHash @{
            SomeSetting = 'blank'
        }
        [Collections.Generic.List[Object]]$Items = @()
    }
    process {
        $items.AddRange(@( $InputObject ))
    }
    end {
        $items
    }
}
