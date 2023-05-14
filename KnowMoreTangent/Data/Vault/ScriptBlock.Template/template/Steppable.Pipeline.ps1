function Export-MySomething {
    <#
    ref:
        seemingly scinece: https://discord.com/channels/180528040881815552/447476117629304853/964691752126668890

        https://discord.com/channels/180528040881815552/447476117629304853/964688000334307408

    .example
        Get-Item . | Export-MySomething -Verbose
    .LINK
        KnowMoreTangent\BaseFunction.FromProxyTemplate
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [psobject] $InputObject
    )
    begin {
        $PSCmdlet.MyInvocation.ExpectingInput | Join-String -f '    ::-begin: ExpectingInput: {0}' | Write-Verbose
        $pipe = { Export-Excel @PSBoundParameters }.GetSteppablePipeline()
        $pipe.Begin($MyInvocation.ExpectingInput)
    }
    process {
        $PSCmdlet.MyInvocation.ExpectingInput | Join-String -f '    ::-proc:  ExpectingInput: {0}' | Write-Verbose
        $pipe.Process($PSItem)
    }
    end {
        $PSCmdlet.MyInvocation.ExpectingInput | Join-String -f '    ::-end:   ExpectingInput: {0}' | Write-Verbose
        $pipe.End()
    }
}
