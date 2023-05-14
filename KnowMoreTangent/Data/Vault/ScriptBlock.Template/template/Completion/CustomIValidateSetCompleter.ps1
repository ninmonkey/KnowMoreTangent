using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Collections
using namespace System.Collections.Generic

<#
https://discord.com/channels/180528040881815552/447476117629304853/1093020781308555315
> santisq
> I think I found a workaround for completion and validation while also defining a validation set dynamically in pwsh 5.1
#>

class ValidateCustomSet : ValidateEnumeratedArgumentsAttribute, IArgumentCompleter {
    static [string[]] $Set
    static [string] $ErrorMessage

    static ValidateCustomSet() {
        if (-not [ValidateCustomSet]::ErrorMessage) {
            [ValidateCustomSet]::ErrorMessage = "'{0}' is not in set! Valid Values '{1}'"
        }
    }

    ValidateCustomSet() { }

    ValidateCustomSet([string] $ErrorMessage) {
        [ValidateCustomSet]::ErrorMessage = $ErrorMessage
    }

    ValidateCustomSet([scriptblock] $Set, [string] $ErrorMessage) {
        [ValidateCustomSet]::Set = $Set.InvokeReturnAsIs()
        [ValidateCustomSet]::ErrorMessage = $ErrorMessage
    }

    ValidateCustomSet([scriptblock] $Set) {
        [ValidateCustomSet]::Set = $Set.InvokeReturnAsIs()
    }

    [void] ValidateElement([object] $Element) {
        if ($Element -notin [ValidateCustomSet]::Set) {
            throw [MetadataException]::new(
                [string]::Format([ValidateCustomSet]::ErrorMessage,
                    $Element, [string]::Join(',', [ValidateCustomSet]::Set))
            )
        }
    }

    [IEnumerable[CompletionResult]] CompleteArgument(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $WordToComplete,
        [CommandAst] $CommandAst,
        [IDictionary] $FakeBoundParameters
    ) {
        [List[CompletionResult]] $result = foreach ($i in [ValidateCustomSet]::Set) {
            if ($i -like "*$wordToComplete*") {
                [CompletionResult]::new("'$i'", $i,
                    [CompletionResultType]::ParameterValue, $i)
            }
        }
        return $result
    }
}
