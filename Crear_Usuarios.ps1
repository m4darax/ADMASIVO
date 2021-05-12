""
Write-Host *********************************************************************************************
Write-Host *********************************************************************************************
Write-Host "          Script para crear usuarios de forma masiva en el directorio activo AUNA.PVT "
           
Write-Host *********************************************************************************************
Write-Host *********************************************************************************************
""
Import-Module ActiveDirectory
[String]$Ruta = Read-Host "Ingrese la ruta donde está el archivo csv (Por Ejemplo C:\archivocsv.csv)"
$dominio=(Get-ADDomain).DNSRoot
Import-Csv -Path $Ruta | foreach-object {
$UPN = $_.Cuenta + "@" + "$dominio"
New-ADUser -SamAccountName $_.Cuenta -UserPrincipalName $UPN -Name $_.Nombre -DisplayName $_.Nombre -SurName $_.Apellidos -GivenName $_.Nombres -Description $_.Descripcion -Office $_.Oficina -OfficePhone $_.Telefono -EmailAddress $_.Email -Title $_.Puesto -Department $_.Area -Company $_.Empresa -Postalcode $_.DNI -State $_.Estado -AccountPassword (ConvertTo-SecureString $_.Clave -AsPlainText -force) -Path $_.OU -Enabled $true -ChangePasswordAtLogon $true -Verbose}
""

Import-Csv -Path $Ruta | foreach-object {
$user = $_.Cuenta
$group = $_.GRUPO
Add-ADGroupMember -Identity $group -Members $user
}


$listado = Import-Csv $Ruta

try {
    del .\resultado.txt

}
catch {  
    echo  "Se creo la carpeta resultado.txt"
}
foreach ($usuario in $listado) {
$correo = $usuario.Cuenta
if (Get-ADUser -Filter {SamAccountName -eq $correo}){
Write-Host “$correo...Si existe en AD”
Write-Output “$correo,Si existe en AD” | Out-File .\resultado.txt -Append
}
else {
Write-Host -BackgroundColor Red -ForegroundColor White “$correo....No existe en AD”
Write-Output “$correo,No existe en AD” | Out-File .\resultadoerror.txt -Append
}
$listado = $Ruta
}

echo " *********************************************************************************************"

echo " *********************************************************************************************"

Write-Host La creacion de usuarios ha finalizado!!!

Start-Sleep -Seconds 699999