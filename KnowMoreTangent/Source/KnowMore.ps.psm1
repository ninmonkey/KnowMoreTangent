write-warning 'left  off; validate *.psm1 returns and includes as expected'
write-warning 'or EzOut type data'
$rootPublic = join-path $PSScriptRoot 'Public'
$rootPrivate = join-path $PSScriptRoot 'Private'
$regexExcludes = @(
    '\.tests.ps1$'
    # '\.ps\.ps1$'
    '\.ps\.psm1$'
    '\.ps\.psd1$'
)
$Private_IncludePattern = '*.ps1'
$public_IncludePattern = '*-*.ps1'
$private_items =  [Include('*.ps1', PassThru)]$rootPrivate  # [Include($private_IncludePattern, PassThru)]$rootPrivate
$public_items  =  [Include('*-*.ps1', PassThru)]$rootPublic # [Include($public_IncludePattern,  PassThru)]$rootPublic

$Private_items | Get-Item | Join.UL | Join-string -op "private items"
$public_items  | Get-Item | Join.UL | Join-string -op "public items"
# $PublicCommands = 'Public'
# [Include('*-*.ps1')]$PublicCommands


# {
#    $Regex_Excludes = ''
#    $PublicCommands = 'Public'

#  } | .>Pipescript


# [Include('*-*.ps1', Exclude='*.ps.psm1', '*.ps.psd1')]$Source } | .>PipeScript

# # :ToIncludeFiles foreach ($file in (Get-ChildItem -Path "$Source" -Filter '*-*.ps1' -Recurse)) {
# #     if ($file.Extension -ne '.ps1') { continue }  # Skip if the extension is not .ps1
# #     if ($file.Name -match '\.tests\.ps1$')
# #     foreach ($exclusion in '\.[^\.]+\.ps1$') {
# #         if (-not $exclusion) { continue }
# #         if ($file.Name -match $exclusion) {
# #             continue ToIncludeFiles  # Skip excluded files
# #         }
# #     }
# #     . $file.FullName
# # }

