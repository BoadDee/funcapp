
<#
.SYNOPSIS
    Create the API backend for the project.
.DESCRIPTION
    This script creates the API backend for the project.
.INPUTS
    Function App Name
.PARAMETER apim
    The name of the APIM instance.
.PARAMETER apimrg
    The name of the APIM resource group.
.PARAMETER func
    The name of the function app.
.PARAMETER subscriptionId
    The subscription ID.
.PARAMETER policyxml
    The path to the policy file.
.PARAMETER rg
    The resource group.
.PARAMETER api
    The name of the API.
.OUTPUTS
    None
.NOTES
.EXAMPLE
#>

param
(
    [Parameter(Mandatory = $true)] [System.Object]$apim,
    [Parameter(Mandatory = $true)] [System.Object]$apimrg,
    [Parameter(Mandatory = $true)] [System.Object]$func,
    [Parameter(Mandatory = $true)] [System.Object]$subscriptionId,
    [Parameter(Mandatory = $true)] [System.Object]$policyxml,
    [Parameter(Mandatory = $true)] [System.Object]$rg,
    [Parameter(Mandatory = $true)] [System.Object]$api
)

Write-host "Get APIM Context.. Started"
$apimContext = New-AzApiManagementContext -ResourceGroupName $apimrg -ServiceName $apim
Write-host "Get APIM Context.. Completed"
Write-host "Get Function App ID.. Started"
$FunctionApp = Get-AzWebApp -ResourceGroupName $rg -Name $func
$Id = $FunctionApp.Id
Write-host "Get Function App ID.. Completed"
Write-host "Get Function App URL properties.. Started"
$DefaultHostName = $FunctionApp.DefaultHostName
$FunctionKey = (Invoke-AzResourceAction -ResourceId "$Id/host/default" -Action listKeys -Force).functionKeys.default

New-AzApiManagementNameValue -Context $apimContext -NameValueId "$func-key" -Value $FunctionKey -secret
$credential = New-AzApiManagementBackendCredential -AuthorizationHeaderScheme basic -Header @{"x-functions-key" = @("{{$func-key}}")}
Write-Host "Get Function App URL properties.. Completed"
Write-Host "Create Backend.. Started"
$backend = New-AzApiManagementBackend -Context $apimContext -BackendId $func -Url "https://$DefaultHostName" -Protocol http -Title "$func" -Credential $credential -Description "Function App $func"
Write-Host "Create Backend.. Completed"

$policyxml
$policy = Get-Content -Path $policyxml
$policy.replace('{{FUNCTIONAPPNAME}}', $func) | set-content -Path $policyxml -force

Write-Host "Set policy.. Started"
Set-AzApiManagementApiPolicy -Context $apimContext -ApiId $api -PolicyFilePath $policyxml
Write-Host "Set policy.. Completed"