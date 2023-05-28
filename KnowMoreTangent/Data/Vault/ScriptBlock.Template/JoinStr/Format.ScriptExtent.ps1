$example = {
    # using grep/vscode filepath syntax, enables jump-to-line number using regular links in the console
    # example output: 'c:\foo\bar.ps1:134'
    $InputObject.Position
        | Join-String {
            $_.File, $_.StartLineNumber -join ':'
        }

}