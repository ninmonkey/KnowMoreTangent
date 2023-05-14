$Template = {
    process {
        $_ | Join-String -sep "`n" -f ' - {0}'
    }
}
<#
Ex:
    'a'..'e' | & $template
#>