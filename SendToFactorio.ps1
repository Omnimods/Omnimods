$BASE = "$env:APPDATA\Factorio\"
$MODS = "mods.dev"


$DIRS = @(
".\omnilib",
".\omnimatter",
".\omnimatter_compression",
".\omnimatter_crystal",
".\omnimatter_permutation",
".\omnimatter_water",
".\omnimatter_wood"
)

$DIRS | %{
    Copy-Item -Path $_ -Destination $BASE\$MODS -Recurse -Force
}