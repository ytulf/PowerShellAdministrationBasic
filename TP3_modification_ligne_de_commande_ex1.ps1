New-ADUser -name "Tyrion LANNISTER" -GivenName Tyrion -Surname LANNISTER -SamAccountName Tlannister `
 -UserPrincipalName tlannister@licence.pro -AccountPassword (Read-host -AsSecureString "AccountPassword") `
-PassThru | Enable-ADAccount 