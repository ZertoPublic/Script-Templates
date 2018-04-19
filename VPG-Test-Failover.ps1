#################################################################
# VPG-Test-Failover.ps1
# 
# By Justin Paul, Zerto Technical Alliances Architect
# Contact info: jp@zerto.com
# Repo: https://www.github.com/Zerto-ta-public/Script-Templates
#
#################################################################

################ Variables for your script ######################

#Zerto Info
$ZVMServer = "172.16.1.20"
$ZVMPort = 9080
$ZVMUser = "administrator"
$ZVMPass = "password"


################ Load Zerto PowerShell SnapIn ###################

Add-PSSnapin Zerto.PS.Commands

################ Start Failover Tests ###########################

#start first VPG
Write-Host "Starting Failover Test for VPG: RDM"
Start-FailoverTest -VirtualProtectionGroup "RDM" -zvmip $ZVMServer -zvmport $ZVMPort -username $ZVMUser -password $ZVMPass -confirm:$False

# wait for 1 minute
Write-Host "Waiting for 2 seconds"
Start-Sleep 2

#start second VPG
Write-Host "Starting Failover Test for VPG: RDM"
Start-FailoverTest -VirtualProtectionGroup "Win-MySQL" -zvmip $ZVMServer -zvmport $ZVMPort -username $ZVMUser -password $ZVMPass -confirm:$False

################ Wait for Keypress before stopping test
Write-Host "\nOnce you have finished testing press any key to cleanup"
$HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
$HOST.UI.RawUI.Flushinputbuffer()

################ Cleanup Failover Tests ########################
Write-Host "\nStopping Failover Test for VPG: RDM"
Stop-FailoverTest -VirtualProtectionGroup "RDM" -zvmip $ZVMServer -zvmport $ZVMPort -username $ZVMUser -password $ZVMPass -confirm:$False

Write-Host "\nStopping Failover Test for VPG: Win-SQL"
Stop-FailoverTest -VirtualProtectionGroup "Win-MySQL" -zvmip $ZVMServer -zvmport $ZVMPort -username $ZVMUser -password $ZVMPass -confirm:$False
