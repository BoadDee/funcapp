
<#
.SYNOPSIS
    Generates the Swagger documentation for the API.
.DESCRIPTION
    This script generates the Swagger documentation for the API.
.PARAMETER rg
    The resource group.
.PARAMETER func
    The name of the function app.
.PARAMETER subscriptionId
    The subscription ID.
.OUTPUTS
    None
.NOTES
.EXAMPLE
#>

param
(
    [Parameter(Mandatory = $true)] [System.Object]$rg,
    [Parameter(Mandatory = $true)] [System.Object]$func,
    [Parameter(Mandatory = $true)] [System.Object]$subscriptionId
)

Write-Host "Get Function App info.. Started"
$FunctionApp = Get-AzWebApp -ResourceGroupName $rg -Name $func
$Id = $FunctionApp.Id
Write-Host "Set Function URL properties.. Started"
$DefaultHostName = $FunctionApp.DefaultHostName
$FunctionURL = $DefaultHostName + "/dre.json"
Write-Host "Swagger url:  $FunctionURL"

Write-host "Get Function App ID.. Completed"
Write-Host "Set Function App URL properties.. Started"
$FunctionKey = (Invoke-AzResourceAction -ResourceId "$Id/host/default" -Action listKeys -Force).functionKeys.default
$token = Get-AzAccessToken -ResourceUrl "https://management.azure.com/"
$headers = @{
    'Authorization' = "bearer $($token.Token)"}

$url = "https://management.azure.com/$subscriptionId/resourceGroups/$rg/providers/Microsoft.Web/sites/$func/functions/http_app_func/listKeys?api-version=2022-03-01"
$key = Invoke-RestMethod -Uri $url -Headers $headers -Method POST
Write-Host "Invoke rest method with convert to json and out to swagger file.."
$apiHeaders = @{
    'x-functions-key' = "$($key.default)"
}

Invoke-RestMethod -Uri $functionURL -Headers $apiHeaders -Method GET | ConvertTo-Json -Depth 100 | Out-File "swagger.json"