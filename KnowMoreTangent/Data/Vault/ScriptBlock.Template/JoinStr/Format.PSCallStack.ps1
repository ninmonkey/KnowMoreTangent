$examples = {
    # look a lot better when the context includes files
    (Get-PSCallStack )[1].InvocationInfo | iot2

    (Get-PSCallStack )[1].InvocationInfo | Join-String { $_.Line }
    (Get-PSCallStack )[1].InvocationInfo | Join-String { $_.MyCommmand }
    (Get-PSCallStack )[1].InvocationInfo | Join-String { $_.PositionMessage }
}