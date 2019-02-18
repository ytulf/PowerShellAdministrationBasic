#get-freespace.ps1

### On ne garde pas le paramètre vu qu'on le récupère dans le fichier
param ($computer = ".", [switch]$total)

Get-WmiObject -Computer $computer win32_logicaldisk | Tee-Object -Variable disques | Select-Object @{e={$_.systemname};n="Systèmes"},
@{e={$_.name};n="Disque"},
@{e={[math]::round($_.freespace/1GB,1)};n="Disponible (Go)"}
if ($total) {
"`nEspace Disponible Total sur $($disques[0].systemname):
$(([math]::round(($disques|measure-object freespace -sum).sum/1GB,1))) Go"} 

