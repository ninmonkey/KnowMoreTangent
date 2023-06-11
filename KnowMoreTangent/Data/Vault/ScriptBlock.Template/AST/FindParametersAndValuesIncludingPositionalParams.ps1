
# long context, starts here and reverse <https://discord.com/channels/180528040881815552/447476117629304853/1112839318218739775>

[System.Management.Automation.Language.StaticParameterBinder]::BindCommand(
    { Get-ChildItem . *.ps1 }.Ast.
    Find({ $args[0] -is [System.Management.Automation.Language.CommandAst] }, $false), $true).
    BoundParameters.GetEnumerator() |
    Select-Object @{ N='ParamName'; E='Key' }, @{ N='Argument'; E={ $_.Value.Value.SafeGetValue() } } 
