$YamlSource = Get-Item -ea 'stop' 'H:\data\2023\pwsh\PsModules\KnowMoreTangent\KnowMoreTangent\Data\Vault\Url\reference ⁞ PowerQuery ⁞ function docs.yml'
$Export = Get-Item 'g:\temp\auto-yaq'

# these flags were important
$yaq = ConvertFrom-Yaml -Yaml (gc -raw $YamlSource) -AllDocuments -Ordered -UseMergingParser
label 'root' '$yaq | ft -auto'
$yaq | ft -auto

$p_exportAsMd = (Join-Path $Export 'source-as.md')

& {
    $p_original = (Join-Path $Export 'source.yml')
    Copy-Item $YamlSource -Destination $P_original
    $p_original | Join-String -f 'source:  <file:///{0}>'

    $p_json = (Join-Path $Export 'source-all-as.json')
    $yaq | Json -depth 10 | sc -Path $p_json
    $p_json | Join-String -f 'as json: <file:///{0}>'
}

function yaml.Export.Segments.AsMarkdownDoc {
    param(
        [Alias('YamlDoc')]$InputObject
    )
    $yaml_docs = @( $InputObject )
    $yaml_docs.count
    | Join-String -op 'Yaml list count: '
    $t_fence = @'

```{0}
{1}
```

'@

    $Id = 0
    foreach ($doc in $yaml_docs) {
        $id++ | Join-String -op '## Yaml doc '

        '### {0} as yaml' -f $id
        # $doc | ConvertTo-Yaml -Options JsonCompatible

        $t_fence -f @(
            'yaml'
            @( $doc | ConvertTo-Yaml )
        )

        '### {0} as json' -f $id

        $t_fence -f @(
            'json'
            @( $doc | Json -depth 12 )
            # @( $doc | ConvertTo-Yaml -Options JsonCompatible )
        )
    }
}
yaml.Export.Segments.AsMarkdownDoc -InputObject $yaq | sc -Path $p_exportAsMd
$p_exportAsMd | Join-String -f 'source:  <file:///{0}>'
