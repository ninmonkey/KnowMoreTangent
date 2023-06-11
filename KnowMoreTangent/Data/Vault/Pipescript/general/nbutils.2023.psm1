$exportParam = @{
    Function = @(
        'nbutils.CsvFirst'
    )
    Alias = @(
        'CsvFirst', 'nb.CsvFirst'
    )
}

function nbutils.CsvFirst {
    <#
    .SYNOPSIS
        sugar to shorten cells, but does a lot more
    .DESCRIPTION
        - truncates list output when past threshold (for notebooks)
        - merges as one line, to use less vertical space (for notebooks)
        - optional pad 0-to-n number of -LinesBefore, -LinesAfter ( -Before n -After n)
        - prefix name
        - does not force a specific stream
        - displays message of how many items were truncated
        - future: maybe supports paging ?
            - notebook has some sort of fancy expanding support, maybe the notebook host
                would take advantage of supports paging
    .EXAMPLE
        'sdf'
        0..4 | CsvFirst

        'a'..'f'| CsvFirst
        0..4    | CsvFirst -after 1


    #>
    # [CmdletBinding()] # can't use else input needs rewrite
    [Alias('CsvFirst', 'nb.CsvFirst')]
    param(
        [ALias('Limit', 'Max')][int]$Count = 15,
        [string]$Label,
        [Alias('After') ][int]$LinesAfter = 0,
        [Alias('Before')][int]$LinesBefore = 0
     )

    end {
        $suffix = if($LinesAfter -gt 0) {
            "`n" * $LinesAfter -join '' } else { [string]::empty }

        $items = @( $Input )
        if($Items.count -gt $Count) {
            $itemsWereTruncated = $true
            $suffix += ', [{0} more...]' -f @( $Items.Count - $Count )
        }

        $items  | Select -First $Count
                | Join-String -sep ', ' -op $Label -os $suffix

        if( -not $ItemsWereTruncated) { return }



            'first {0} of {1} items' -f @(
                $Count
                $Items.Count
            )
            | write-host -back darkmagenta
    }
}

$ExportParam.Function
    | Join-String -sep ', ' -SingleQuote -op 'exportMemberFuncs: '
    | write-verbose
$ExportParam.Alias
    | Join-String -sep ', ' -SingleQuote -op 'exportMemberAlias: '
    | write-verbose

Export-ModuleMember @exportParam