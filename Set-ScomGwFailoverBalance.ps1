$allMS = Get-SCOMManagementServer | ? {$_.IsGateway -eq $false}
$allGW = Get-SCOMManagementServer | ? {$_.IsGateway -eq $true}
$countMS = 0

foreach ($oneGW in $allGW) {
    "-"*10
    $countMS
    write-host "Gateway:     " $oneGW.PrincipalName

    # set primary:
    write-host "Primary MS:  " $allMS[$countMS].PrincipalName
    $primaryMS = $allMS[$countMS]

    #set failover:
    if ($countMS -lt ($allMS.Count-1)) {
        write-host "Failover MS: " $allMS[($countMS)+1].PrincipalName
        $failoverMS =  $allMS[($countMS)+1]
    } else {
        write-host "Failover MS: " $allMS[0].PrincipalName
        $failoverMS =  $allMS[0]
    }
    Set-SCOMParentManagementServer -GatewayServer $oneGw -FailoverServer $NULL #-WhatIf
    Set-SCOMParentManagementServer -GatewayServer $oneGw -FailoverServer $failoverMS #-WhatIf

    # count
    if ($countMS -eq ($allMS.Count-1)) {
        $countMS = 0
    } else {
        $countMS = $countMS+1
    }
}