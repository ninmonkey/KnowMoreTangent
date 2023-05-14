function Get-NoMoreVault {
    <#
    .SYNOPSIS
        Find a list of the satashes,
    .notes
        maybe name like
    #>
    [Alias( # maybe name using the [SecretManagement] pattern
        'Get-NoMoreStashInfo',
        'Get-NoMoreVaultInfo'
    )]
    [CmdletBinding()]
    param()
}

function Get-NoMoreVaultInfo {
    <#
    .SYNOPSIS
        Find a list of the satashes,
    .notes
        maybe name like
    #>
    [Alias( # maybe name using the [SecretManagement] pattern
        'Get-NoMoreVaultInfo'
    )]
    [CmdletBinding()]
    param()
}


function Get-NoMore {
    <#
    .SYNOPSIS
        Find a list of the satashes,
    .notes
        maybe name like
    #>
    [Alias( # maybe name using the [SecretManagement] pattern
        # 'Get-NoMoreVaultInfo'
    )]
    [CmdletBinding()]
    param(
        # [ArgumentCompletions('Color', 'Path', 'Dates', 'Regex')]
        [ValidateSet('Color', 'Path', 'Dates', 'Regex')]
        [Alias('Name')]
        [Parameter(Mandatory, Position = 0)]$Vault,


        [ArgumentCompletions('todo-will-be-custom-since-allkey-can-auto-complete')]
        [Alias('Key')]
        [Parameter(Mandatory, Position = 1)]$Name
    )


    $InformationPreference = 'Continue'
    '::NoMore: { stash: {0}, key: {1} }' -f @(
        $
    ) | Write-Information
}