### Création des Unités Organisationnelles 
New-ADOrganizationalUnit -Name "Etudiants" -Path "dc=lprt,dc=fr"
New-ADOrganizationalUnit -Name "FI" -Path "ou=Etudiants,dc=lprt,dc=fr"
New-ADOrganizationalUnit -Name "FC" -Path "ou=Etudiants,dc=lprt,dc=fr"

### Création des utilisateurs il faudrait mieux créer une boucle pour le faire 
New-ADUser -name "User1" -AccountPassword (Convertto-SecureString "P@ssw0rd" -AsPlainText -Force) -Enable $true -Path "OU=FI,OU=Etudiants,DC=lprt,DC=fr"
New-ADUser -name "User2" -AccountPassword (Convertto-SecureString "P@ssw0rd" -AsPlainText -Force) -Enable $true -Path "OU=FI,OU=Etudiants,DC=lprt,DC=fr"
New-ADUser -name "User3" -AccountPassword (Convertto-SecureString "P@ssw0rd" -AsPlainText -Force) -Enable $true -Path "OU=FC,OU=Etudiants,DC=lprt,DC=fr"
New-ADUser -name "User4" -AccountPassword (Convertto-SecureString "P@ssw0rd" -AsPlainText -Force) -Enable $true -Path "OU=FC,OU=Etudiants,DC=lprt,DC=fr"

### Création des groupes et attribution des utilisateurs
New-ADGroup -name "gg_etudiants" -GroupScope DomainLocal
Add-ADGroupMember -Identity "gg_etudiants" -Member "CN=User1,OU=FI,OU=Etudiants,DC=lprt,DC=fr"
Add-ADGroupMember -Identity "gg_etudiants" -Member "CN=User2,OU=FI,OU=Etudiants,DC=lprt,DC=fr"
Add-ADGroupMember -Identity "gg_etudiants" -Member "CN=User3,OU=FC,OU=Etudiants,DC=lprt,DC=fr"
Add-ADGroupMember -Identity "gg_etudiants" -Member "CN=User4,OU=FC,OU=Etudiants,DC=lprt,DC=fr"
New-ADGroup -name "gg_fi" -GroupScope DomainLocal
Add-ADGroupMember -Identity "gg_fi" -Member "CN=User1,OU=FI,OU=Etudiants,DC=lprt,DC=fr"
Add-ADGroupMember -Identity "gg_fi" -Member "CN=User2,OU=FI,OU=Etudiants,DC=lprt,DC=fr"
New-ADGroup -name "gg_fc" -GroupScope DomainLocal
Add-ADGroupMember -Identity "gg_fc" -Member "CN=User3,OU=FC,OU=Etudiants,DC=lprt,DC=fr"
Add-ADGroupMember -Identity "gg_fc" -Member "CN=User4,OU=FC,OU=Etudiants,DC=lprt,DC=fr"
### On affiche les utilisateurs et ensuite les utilisateurs des groupes
Get-ADUser -filter * | Format-List | findstr User[0-9]
Get-ADGroupMember -Identity gg_etudiants 