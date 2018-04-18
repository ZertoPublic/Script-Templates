#################################################################
# powershell-template.ps1
# 
# By Justin Paul, Zerto Technical Alliances Architect
# Contact info: jp@zerto.com
# Repo: https://www.github.com/Zerto-ta-public/Script-Templates
#
#################################################################

################ Variables for your script ######################

#Zerto Info
$VPGName = "MyVPG"
$ZVMServer = "172.16.1.20"
$ZVMPort = 9080
$ZVMUser = "administrator"
$ZVMPass = "password"


################ Load Zerto PowerShell SnapIn ###################

Add-PSSnapin Zerto.PS.Commands

################ Your Code Below Here ###########################


