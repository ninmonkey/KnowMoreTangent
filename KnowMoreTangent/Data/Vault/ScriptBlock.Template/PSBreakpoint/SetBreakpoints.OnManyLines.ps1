# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-psbreakpoint?view=powershell-7.3&WT.mc_id=ps-gethelp#example-5-set-a-breakpoint-depending-on-the-value-of-a-variable
Set-PSBreakpoint -Script "test.ps1" -Command "DiskTest" -Action { if ($Disk -gt 2) { break } }
Set-PSBreakpoint -Script "sample.ps1" -Line 1, 14, 19 -Column 2 -Action {&(log.ps1)}
<#
When the -Action parameter is used,
    - the Action script block runs at each breakpoint.
    - Execution does not stop unless the script block includes the Break keyword.
    - If you use the Continue keyword in the script block, execution resumes until the next breakpoint.
#>
# or runspace
$runspace = Get-Runspace -Id 1
Set-PSBreakpoint -Command Start-Sleep -Runspace $runspace