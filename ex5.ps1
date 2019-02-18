$cat = get-content C:\Users\Administrateur\Desktop\user.txt
foreach($user in $cat){
New-Item -name "Essai\dossier_$user" -ItemType directory
}