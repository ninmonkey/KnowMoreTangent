Write-Error 'NYI: Next'

$lastClip ??= gcl | Sort-Object -Unique
function Build-GenerateFromEsClipboard {
    [CmdletBinding()]
    param(
        [Parameter()]
        $InputObject
    )
    [pscustomobject]@{
        PSTypeName = 'LocationHistory.Record.KnowItExperimentType'

    }
    Get-Clipboard
    | Get-Item -ea 'stop'
    # __buildHistoryFromClipBoardFromEverythingSearchQuery
    $stuff.count
}

Build-GenerateFromEsClipboard -inputObject $lastClip