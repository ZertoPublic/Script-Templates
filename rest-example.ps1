$strZVMIP = "{ZVM IP}"
$strZVMPort = "{ZVM HTTPS port}"
$strZVMUser = "{ZVM user}"
$strZVMPwd = "{ZVM user password}"

## Perform authentication so that Zerto APIs can run. Return a session identifier that needs to be inserted in the header for subsequent requests.
function getxZertoSession ($userName, $password){
  $baseURL = "https://" + $strZVMIP + ":"+$strZVMPort
  $xZertoSessionURL = $baseURL +"/v1/session/add"
  $authInfo = ("{0}:{1}" -f $userName,$password)
  $authInfo = [System.Text.Encoding]::UTF8.GetBytes($authInfo)
  $authInfo = [System.Convert]::ToBase64String($authInfo)
  $headers = @{Authorization=("Basic {0}" -f $authInfo)}
  $contentType = "application/json"
  $xZertoSessionResponse = Invoke-WebRequest -Uri $xZertoSessionURL -Headers $headers -Method POST -Body $body -ContentType $contentType
 
    #$xZertoSessionResponse = Invoke-WebRequest -Uri $xZertoSessionURL -Headers $headers -Body $body -Method POST
    return $xZertoSessionResponse.headers.get_item("x-zerto-session")
}
 
#Extract x-zerto-session from the response, and add it to the actual API:
$xZertoSession = getxZertoSession $strZVMUser $strZVMPwd
$zertoSessionHeader = @{"x-zerto-session"=$xZertoSession}
$zertoSessionHeader_xml = @{"Accept"="application/xml"
"x-zerto-session"=$xZertoSession}
 
#Invoke the Zerto API:
$vpgListApiUrl = "https://" + $strZVMIP + ":"+$strZVMPort+"/v1/vpgs"
$VPGNAME = "MyApp"
#Iterate with XML:
$vpgListXML = Invoke-RestMethod -Uri $vpgListApiUrl -Headers $zertoSessionHeader_xml
foreach ($vpg in $vpgListXML.ArrayOfVpgApi.VpgApi){
  if ($vpg.VpgName -eq $VPGNAME){
    $tmpVpgIdentifier = $vpg.VpgIdentifier
    break
  }
}
#Iterate with JSON:
$vpgListJSON = Invoke-RestMethod -Uri $vpgListApiUrl -Headers $zertoSessionHeader
foreach ($vpg in $vpgListJSON){
  if ($vpg.VpgName -eq $VPGNAME){
    $tmpVpgIdentifier = $vpg.VpgIdentifier
    break
  }
}
write-host $tmpVpgIdentifier
##End of script
