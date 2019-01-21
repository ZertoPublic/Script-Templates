#################################################################
# Template-Zerto-Analytics-REST.ps1
# 
# By Justin Paul, Zerto Technical Alliances Architect
# Contact info: jp@zerto.com
# Repo: https://www.github.com/Zerto-ta-public/Script-Templates
#
# Legal stuff
# This script is an example script and is not supported under any Zerto support program or service. 
# The author and Zerto further disclaim all implied warranties including, without limitation, any implied 
# warranties of merchantability or of fitness for a particular purpose.
#
# In no event shall Zerto, its authors or anyone else involved in the creation, production or delivery of 
# the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business 
# profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use 
# of or the inability to use the sample scripts or documentation, even if the author or Zerto has been advised 
# of the possibility of such damages. The entire risk arising out of the use or performance of the sample scripts 
# and documentation remains with you.
#
#################################################################

################ Variables for your script ######################

$strZaUrl = "analytics.api.zerto.com"
$strZAUser = "me@domain.com"
$strZAPwd = "mypassword"

## Perform authentication so that Zerto APIs can run. Return a bearer token that needs to be inserted in the header for subsequent requests.
function getZertoAnalyticsAuthToken ($userName, $password){
    $baseURL = "https://" + $strZaUrl
    $xZertoSessionURL = $baseURL +"/v2/auth/token"
    $params = @{
        "username"="$strZAUser"
        "password"="$strZAPwd"
    }
    $contentType = "application/json"
    $xZertoSessionResponse = Invoke-RESTMethod -Uri $xZertoSessionURL -Method POST -Body ($params|ConvertTo-Json) -ContentType $contentType
    return $xZertoSessionResponse.token
}

#Setup Zerto Analytics Header information with new token:
$xZertoSession = getZertoAnalyticsAuthToken $strZVMUser $strZVMPwd
$zertoSessionHeader = @{"accept"="application/json"
    'Authorization' = "Bearer $($xZertoSession)"}

################ Your Script starts here #######################
#Invoke the Zerto API:
$peerListApiUrl = "https://" + $strZaUrl + "/v2/monitoring/sites"
$peerListJSON = Invoke-RestMethod -Uri $peerListApiUrl -H $zertoSessionHeader

#Iterate with JSON:
foreach ($peer in $peerListJSON){
    Write-Host $peer.zvmIp  $peer.name $peer.type $peer.version $peer.connectionStatus
}

##End of script
