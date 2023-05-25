<#
refs: <https://pester.dev/docs/usage/configuration>
docs: <https://pester.dev/docs/commands/Invoke-Pester>
and : <https://pester.dev/docs/commands/New-PesterConfiguration>
ex  : <https://pester.dev/docs/commands/New-PesterConfiguration#examples>
#>

$PesterPreference = [PesterConfiguration]::Default
$PesterPreference.Debug.WriteDebugMessages = $true
[bool]$lastFlip ??= $true

if ( ( $lastFlip = -not $lastFlip ) ) {
    # every other run is verbose. why? for fun.
    $PesterPreference.Debug.WriteDebugMessages = $false
}
$PesterPreference.Debug.WriteDebugMessagesFrom = 'Mock'

BeforeAll {
    function a { 'hello' }
}
Describe 'pester preference' {
    It 'mocks' {
        Mock a { 'mock' }
        a | Should -Be 'mock'
    }
}