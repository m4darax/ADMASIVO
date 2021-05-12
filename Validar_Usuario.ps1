
[String]$Ruta = Read-Host "Ingrese la ruta donde está el archivo csv (Por Ejemplo C:\file.csv)"
$listado = Import-Csv $Ruta

foreach ($usuario in $listado) {
$correo = $usuario.Cuenta
if (Get-ADUser -Filter {SamAccountName -eq $correo}){
Write-Host “$correo...Si existe en AD”
Write-Output “$correo,Si existe en AD” | Out-File .\resultado.txt -Append
}
else {
Write-Host -BackgroundColor Red -ForegroundColor White “$correo....Usuario no existe AD”
Write-Output “$correo,No existe en AD” | Out-File .\resultadoerror.txt -Append
}
$listado = $Ruta
}