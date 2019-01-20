#################################################################
# Template-Zerto-Analytics-REST.ps1
# 
# By Justin Paul, Zerto Technical Alliances Architect
# Contact info: jp@zerto.com
# Repo: https://www.github.com/Zerto-ta-public/Script-Templates
#
#################################################################

################ Variables for your script ######################

$strZaUrl = "analytics.api.zerto.com"
$strZAUser = "me@domain.com"
$strZAPwd = "mypassword"

## Perform authentication so that Zerto APIs can run. Return a session identifier that needs tobe inserted in the header for subsequent requests.
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

#Extract x-zerto-session from the response, and add it to the actual API:
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
