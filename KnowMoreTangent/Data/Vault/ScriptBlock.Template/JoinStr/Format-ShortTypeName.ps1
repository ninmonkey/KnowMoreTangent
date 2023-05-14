$template = {
    Get-Command Get-ChildItem | ForEach-Object pstypenames | Join-String -sep ', ' { $_ -split '\.' | Select-Object -Last 1 | Join-String -f '[{0}]' } # Grab last name of type from text only
}