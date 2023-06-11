# source: chris, seemingly scie, santisq: <https://discord.com/channels/180528040881815552/447476117629304853/1112839318218739775>

$sourceScript = {
    New-PSUScript -Name "ScriptName.ps1" -Path "Folder\ScriptName.ps1" -Environment "PowerShell7" -InformationAction "Continue" -Description "What the script does goes here"
    New-PSUScript -Name "OtherScript.ps1" -Path "OtherScript.ps1" -Environment "PowerShell7" -InformationAction "Continue" -Description "What the script does goes here"
}

$sourceScript.Ast.FindAll(
    { $args[0] -is [CommandAst] },
    $false
) | ForEach-Object {
    $output = [Ordered]@{
        CommandName  = $_.GetCommandName()
        CommandStart = $_.Extent.StartOffset
    }
    foreach ($parameter in [System.Management.Automation.Language.StaticParameterBinder]::BindCommand($_).BoundParameters.GetEnumerator()) {
        $output[$parameter.Key] = $parameter.Value.Value.SafeGetValue()
    }
    [PSCustomObject]$output
}|ft



<# outputs:
   {0}
#>
