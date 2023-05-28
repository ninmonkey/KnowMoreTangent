$rootPublic = join-path $PSScriptRoot 'Public'
$rootPrivate = join-path $PSScriptRoot 'Private'

$private_items =  :ToIncludeFiles foreach ($file in (Get-ChildItem -Path "$rootPrivate" -Filter "*-*.ps1" -Recurse)) {
                      if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
                      foreach ($exclusion in '\.[^\.]+\.ps1$') {
                          if (-not $exclusion) { continue }
                          if ($file.Name -match $exclusion) {
                              continue ToIncludeFiles  # Skip excluded files
                          }
                      }
                      . $file.FullName
                      $file
                  }
$public_items  =  :ToIncludeFiles foreach ($file in (Get-ChildItem -Path "$rootPublic" -Filter "*-*.ps1" -Recurse)) {
                      if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
                      foreach ($exclusion in '\.[^\.]+\.ps1$') {
                          if (-not $exclusion) { continue }
                          if ($file.Name -match $exclusion) {
                              continue ToIncludeFiles  # Skip excluded files
                          }
                      }
                      . $file.FullName
                      $file
                  }


$Private_items | gi | Join.UL | Join-string -op "private items"
$public_items  | gi | Join.UL | Join-string -op "public items"
$PublicCommands = 'Public'
:ToIncludeFiles foreach ($file in (Get-ChildItem -Path "$PublicCommands" -Filter "*-*.ps1" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    foreach ($exclusion in '\.[^\.]+\.ps1$') {
        if (-not $exclusion) { continue }
        if ($file.Name -match $exclusion) {
            continue ToIncludeFiles  # Skip excluded files
        }
    }
    . $file.FullName
}


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


