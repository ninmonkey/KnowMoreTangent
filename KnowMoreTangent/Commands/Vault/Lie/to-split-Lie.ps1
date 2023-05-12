
$script:xlr8r = [psobject].assembly.gettype('System.Management.Automation.TypeAccelerators')
function Remove-Lie {
    <#
    .SYNOPSIS
        [collection pattern] AFAIK I don't thikkI don't think there's a clean way, ora
    .NOTES
        AFAIK there isn't a clean way to remove type accelerators
        They might appear to unload, to the session, but doesn't actually delete it
    .EXAMPLE
        $xlr8r::Remove( )
    #>
    param(
        # type kind. later remove ky key sintead.
        [Parameter(Mandatory, Position = 0)]$TypeInfo
    )
    'AFAIK api doesn''t expose ability to remove?'
    throw 'does not remove, is internally cached, jborean''s patch might have fixed that, or at least shows whether it''s a new type'
    # $script:xlr8r ??= [psobject].assembly.gettype('System.Management.Automation.TypeAccelerators')
    $script:xlr8r::Remove($TypeInfo)
    'Removed Lie: {0}. Remaining Lies: {1}' -f @(
        $Name
        $script:xlr8r.Keys.count
    ) | Write-Information -infa 'continue'
}
