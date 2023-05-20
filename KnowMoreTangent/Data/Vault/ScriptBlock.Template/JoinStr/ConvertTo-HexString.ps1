# works for int
255 - 20 | Join-String -f '{0:x}'
# decimal needs cast
.3 * 255 -as 'int' | Join-String -f '{0:x}'

$case1 = 255 - 20
$case2 = 0.3 * 255

$case1, $case2 -join ', '
$case1, $case2 | Join-String -f "`nitem: {0}"

# errors on non int
$case1, $case2 | Join-String -f "`nitem: {0:x}"

# could cast normally on one
$case2 -as 'int' | Join-String -f "`nitem: {0:x}"

# calculated property always works
$case2 | Join-String -f "`nitem: {0:x}" -Property { $_ -as 'int' }

