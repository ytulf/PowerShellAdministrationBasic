$elements = Get-WmiObject Win32_LogicalDisk # Création de l'instance de l'objet WMI
$taille_total = 0 # Initialisation de la variable

#Initialisation de la boucle pour parcourir les disques
foreach($disque in $elements) {
# En Mégaoctet
$taille = $disque.FreeSpace / (1024*1024)
$taille = [math]::Round($taille, 1) # On arrondi la taille
$nom = $disque.Name
$taille_total = $taille_total + $taille
Write-Host "Le disque : $nom a $taille Mo de disponible" 
}
Write-Host "Taille disponible cumulée = $taille_total Mo"