{
    New-PSUScript -Name "ScriptName.ps1" -Path "Folder\ScriptName.ps1" -Environment "PowerShell7" -InformationAction "Continue" -Description "What the script does goes here"
    New-PSUScript -Name "OtherScript.ps1" -Path "OtherScript.ps1" -Environment "PowerShell7" -InformationAction "Continue" -Description "What the script does goes here"
}.Ast.FindAll(
    { $args[0] -is [CommandAst] },
    $false
) | ForEach-Object {
    $boundParameters = [StaticParameterBinder]::BindCommand($_).BoundParameters
    [PSCustomObject]@{
        CommandName  = $_.GetCommandName()
        CommandStart = $_.Extent.StartOffset
        Name         = $boundParameters['Name'].Value?.SafeGetValue()
        Description  = $boundParameters['Description'].Value?.SafeGetValue()
    }
}
