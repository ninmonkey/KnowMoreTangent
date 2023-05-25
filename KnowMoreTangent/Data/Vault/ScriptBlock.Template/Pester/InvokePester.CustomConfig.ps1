<#
refs: <https://pester.dev/docs/usage/configuration>
docs: <https://pester.dev/docs/commands/Invoke-Pester>
and : <https://pester.dev/docs/commands/New-PesterConfiguration>
ex  : <https://pester.dev/docs/commands/New-PesterConfiguration#examples>
#>
# import module before creating the object
Import-Module Pester
# get default from static property
$configuration = [PesterConfiguration]::Default
# assing properties & discover via intellisense
$configuration.Run.Path = 'C:\projects\tst'
$configuration.Filter.Tag = 'Acceptance'
$configuration.Filter.ExcludeTag = 'WindowsOnly'
$configuration.Should.ErrorAction = 'Continue'
$configuration.CodeCoverage.Enabled = $true

# cast whole hashtable to configuration
$configuration = [PesterConfiguration]@{
    Run          = @{
        Path = 'C:\projects\tst'
    }
    Filter       = @{
        Tag        = 'Acceptance'
        ExcludeTag = 'WindowsOnly'
    }
    Should       = @{
        ErrorAction = 'Continue'
    }
    CodeCoverage = @{
        Enabled = $true
    }
}

# cast from empty hashtable to get default
$configuration = [PesterConfiguration]@{}
$configuration.Run.Path = 'C:\projects\tst'
# cast hashtable to section
$configuration.Filter = @{
    Tag        = 'Acceptance'
    ExcludeTag = 'WindowsOnly'
}
$configuration.Should.ErrorAction = 'Continue'
$configuration.CodeCoverage.Enabled = $true