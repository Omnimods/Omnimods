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

$PROG = (Get-Content $BASE\factorio-current.log -TotalCount 3)[2]
$PROG = ($PROG -split "`"")[1]

Start-Process -FilePath $PROG -ArgumentList "--mod-directory `"$BASE$MODS`" --load-game `"$BASE`saves\Test-2.zip" -WorkingDirectory (Split-Path $PROG -Parent) -Wait -NoNewWindow