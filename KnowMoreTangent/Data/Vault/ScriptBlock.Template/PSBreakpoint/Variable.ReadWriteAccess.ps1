Set-PSBreakpoint -Variable 'foo' -Action { $null -eq $global:eis } -Mode 'Read'
Set-PSBreakpoint -Variable 'bar' -Mode 'ReadWrite'