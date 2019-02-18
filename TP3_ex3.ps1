# Créer un dossier quelconque et affectez lui des permissions particulières 'alpha'
### On créer le répertoire
New-Item -ItemType directory -Path .\dossier_permission 
$permission = get-acl -path .\dossier_permission 
$perm = $env:USERNAME, 'Read,Modify', 'containerinherit, objectinherit', 'none', 'allow'
$règle = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
$permission.SetAccessRule($règle)
$permission | set-acl -path .\dossier_permission
pause

# Testez la commande Get-acl sur ce dossier. Est-ce en accord avec les permissions précédemment affectées?
get-acl -path ".\dossier_permission"
pause

# Créez une centaine de répertoire (avec un script bien sur...)
for($i=0;$i -lt 100; $i++){new-item -ItemType directory -Path ".\dossier_permission\directory_$i"}
pause

# Affectez avec la commande Set-Acl les permissions 'alpha' à chacun de ces nouveaux répertoires
for($i=0;$i -lt 100; $i++){get-acl -path .\dossier_permission | set-acl -path ".\dossier_permission\directory_$i"}
pause

# Tester ces commandes avec des répertoires partagés 
### On créer le dossier partagé "partag"
New-Item -ItemType directory -Path \\192.168.1.100\partage 
### On modifie ces permissions
$permission = get-acl -path \\192.168.1.100\partage 
$perm = $env:USERNAME, 'Read,Modify', 'containerinherit, objectinherit', 'none', 'allow'
$règle = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
$permission.SetAccessRule($règle)
$permission | set-acl -path \\192.168.1.100\partage 
### On test la commande get-acl sur le dossier
get-acl -path "\\192.168.1.100\partage"
### On créer 100 sous-dossiers
for($i=0;$i -lt 100; $i++){new-item -ItemType directory -Path "\\192.168.1.100\partage\directory_$i"}
### On change les permissions de tous les sous-dossiers
for($i=0;$i -lt 100; $i++){get-acl -path \\192.168.1.100\partage | set-acl -path "\\192.168.1.100\partage\directory_$i"}
pause

# Proposer un script, qui à partir d'un dossier qui a des permissions 'beta', ajoute le contrôle total pour un utilisateur donné
$nom_du_dossier = Write-host "Selection des permissions du dossier : dossier_permission"
pause
$permissions_du_fichier_voulu = get-acl .\dossier_permission
$utilisateur_souhaité = read-host "Nom de l'utilisateur souhaité (Attention : Il faut que l'utilisateur soit déjà créer) "
$controle = New-Object System.Security.AccessControl.FileSystemAccessRule($utilisateur_souhaité,"FullControl","Allow")
$permissions_du_fichier_voulu.SetAccessRule($controle)
set-acl -Path .\dossier_permission $permissions_du_fichier_voulu