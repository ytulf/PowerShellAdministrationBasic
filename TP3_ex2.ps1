[system.reflection.assembly]::loadwithpartialname("system.windows.forms")
[system.reflection.assembly]::loadwithpartialname("system.drawing")
### Ou ADD-type -assemblyname system.windows.forms

$mainform = New-object system.windows.forms.form

$mainform.startposition = "centerscreen"
$mainform.text = "Import des utilisateurs et des groupes"
$mainform.width = 500
$mainform.height = 500

### Button Quitter
$button = new-object system.windows.forms.button
$button.Text = "Quitter"
$button.Size = new-object system.drawing.size (350,35)
$button.Location = new-object system.drawing.size (75,300)
$button.Add_click(
{
$popup = New-Object -ComObject Wscript.shell
$popup.popup("Fermeture du script",0x0,"Fermeture",0x0)
$mainform.close()
}
)
### Button Importer
$button2 = new-object system.windows.forms.button
$button2.Text = "Importer"
$button2.Size = new-object system.drawing.size (350,35)
$button2.Location = new-object system.drawing.size (75,250)

### Sidebar pour la création des fichiers textes
$sidebar_fichiers_textes = new-object System.Windows.Forms.ProgressBar
$sidebar_fichiers_textes.Size = new-object system.drawing.size (350,35)
$sidebar_fichiers_textes.Location = new-object system.drawing.size (75,50)
$sidebar_fichiers_textes.value = 0
$sidebar_fichiers_textes.Maximum = 12
$sidebar_fichiers_textes.text = "Progression de la création des fichiers"

### Sidebar pour la création des utilisateurs
$sidebar_creation_user = new-object System.Windows.Forms.ProgressBar
$sidebar_creation_user.Size = new-object system.drawing.size (350,35)
$sidebar_creation_user.Location = new-object system.drawing.size (75,130)
$sidebar_creation_user.value = 0
$sidebar_creation_user.maximum = 250
$sidebar_creation_user.text = "Progression de l'ajout des utilisateurs"

### Sidebar pour l'ajout aux groupes 
$sidebar_ajout_groupe = new-object System.Windows.Forms.ProgressBar
$sidebar_ajout_groupe.Size = new-object system.drawing.size (350,35)
$sidebar_ajout_groupe.Location = new-object system.drawing.size (75,200)
$sidebar_ajout_groupe.value = 0
$sidebar_ajout_groupe.maximum = 251
$sidebar_ajout_groupe.text = "Progression de l'ajout des utilisateurs dans les groupes"
$button2.Add_click(
{
# Création des listes
### Création de la liste des utilisateurs
$ligne_user = New-Item -ItemType file -Path user.txt -Force
$sidebar_fichiers_textes.value ++
### Création de la liste des groupes
$ligne_group = New-Item -ItemType file -Path group.txt -Force
$sidebar_fichiers_textes.value ++
# Création des utilisateurs, groupes
### Création des 250 utilisateurs nommé Utilisateur_1, ...
for($i=0;$i -le 9;$i++){Add-content -Path $ligne_user -Value "Utilisateur_0$i"}
$sidebar_fichiers_textes.value ++
for($i=10;$i -lt 250;$i++){Add-content -Path $ligne_user -Value "Utilisateur_$i"}
$sidebar_fichiers_textes.value ++
### Création des 25 groupes nommé Group_1, ...
for($j=0;$j -lt 25;$j++){Add-content -Path $ligne_group -Value "Groupe_$j"}
$sidebar_fichiers_textes.value ++
### On créer les groupes 
for($j=0;$j -lt 25;$j++){New-ADGroup -name "Groupe_$j" -GroupScope DomainLocal}
$sidebar_fichiers_textes.value ++

# On met tout dans un csv
$ajout_csv = New-Item -ItemType file -Path ajout.csv -Force
$sidebar_fichiers_textes.value ++
Add-content -Path $ajout_csv -value "Group;user0;user1;user2;user3;user4;user5;user6;user7;user8;user9"
for($u=0;$u -lt 25;$u++){Add-content -Path $ajout_csv -Value "Groupe_$u;Utilisateur_$u.0;Utilisateur_$u.1;Utilisateur_$u.2;Utilisateur_$u.3;Utilisateur_$u.4;Utilisateur_$u.5;Utilisateur_$u.6;Utilisateur_$u.7;Utilisateur_$u.8;Utilisateur_$u.9"}
$sidebar_fichiers_textes.value ++
### On enlève les points 
$a = get-content .\ajout.csv | foreach{$_ -replace "\.",""}
$sidebar_fichiers_textes.value ++
### Et on renvoie vers le fichier
Set-Content -path ".\ajout.csv" -value $a
$sidebar_fichiers_textes.value ++

# On met le contenu dans des variables et on créer ou ajoute les utilisateurs dans leurs groupes idoines
$cat_user = Get-Content .\user.txt
$sidebar_fichiers_textes.value ++
$cat_ajout = Import-Csv -Path .\ajout.csv -Delimiter ";"
$sidebar_fichiers_textes.value ++
### On créer les utilisateurs en fonction de la liste prédéfinie :
foreach($item in $cat_user) {
New-ADUser -name $item -AccountPassword (Convertto-SecureString "P@ssw0rd" -AsPlainText -Force) -Enable $true -Path "OU=Etudiants,DC=lprt,DC=fr"
$sidebar_creation_user.value ++
}
### On ajoute les utilisateurs dans leurs groupes idoines
foreach($elements in $cat_ajout){
$group = $elements.Group
$user0 = $elements.user0
$user1 = $elements.user1
$user2 = $elements.user2
$user3 = $elements.user3
$user4 = $elements.user4
$user5 = $elements.user5
$user6 = $elements.user6
$user7 = $elements.user7
$user8 = $elements.user8
$user9 = $elements.user9
$liste_user = $user0, $user1, $user2, $user3, $user4, $user5, $user6, $user7, $user8, $user9
for($i = 0; $i -le 9; $i ++){
Add-ADGroupMember -Identity "$group" -Member $liste_user[$i]
$sidebar_ajout_groupe.value ++
}
}
}
)
### Création des textes au dessus des sidebars
$text = new-object System.Windows.Forms.Label
$text.text = "Progression de la création des fichiers :"
$text.Size = new-object system.drawing.size (350,35)
$text.Location = new-object system.drawing.size (75,20)
$text.font = New-Object System.Drawing.Font("Arial",9,[drawing.fontstyle]'bold')

$text2 = new-object System.Windows.Forms.Label
$text2.text = "Progression de l'ajout des utilisateurs et des groupes :"
$text2.Size = new-object system.drawing.size (350,35)
$text2.Location = new-object system.drawing.size (75,100)
$text2.font = New-Object System.Drawing.Font("Arial",9,[drawing.fontstyle]'bold')

$text3 = new-object System.Windows.Forms.Label
$text3.text = "Progression de l'ajout des utilisateurs dans les groupes :"
$text3.Size = new-object system.drawing.size (350,35)
$text3.Location = new-object system.drawing.size (75,175)
$text3.font = New-Object System.Drawing.Font("Arial",9,[drawing.fontstyle]'bold')


$text4 = new-object System.Windows.Forms.Label
$text4.text = "Créer par SAVIO Thomas"
$text4.Size = new-object system.drawing.size (350,35)
$text4.Location = new-object system.drawing.size (20,450)
$text4.font = New-Object System.Drawing.Font("Arial",6,[drawing.fontstyle]'bold')

### Affichage 
$mainform.Controls.add($button)
$mainform.Controls.add($button2)
$mainform.Controls.add($sidebar_creation_user)
$mainform.Controls.add($sidebar_ajout_groupe)
$mainform.Controls.add($sidebar_fichiers_textes)
$mainform.Controls.add($text)
$mainform.Controls.add($text2)
$mainform.Controls.add($text3)
$mainform.Controls.add($text4)
$mainform.showdialog()
