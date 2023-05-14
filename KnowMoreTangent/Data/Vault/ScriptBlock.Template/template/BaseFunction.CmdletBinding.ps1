function Template-WithoutPipeline {
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
        [Parameter(Mandatory, Position = 0)]
        [object[]]$InputObject,

        # Expose additional settings, ie: it's **kwargs
        [ArgumentCompletions(
            '@{ SomeSetting = "blank" }'
        )]
        [Alias('Kwargs')]
        [Parameter()][hashtable]$Options = @{}
    )

    $Config = Ninmonkey.Console\Join-Hashtable -OtherHash $Options -BaseHash @{
        SomeSetting = 'blank'
    }

}
