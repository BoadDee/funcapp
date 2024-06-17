
<#
.SYNOPSIS
    Import API Definition to API Management Service
.DESCRIPTION
    This script imports the API definition to the API Management Service.
.PARAMETER apim
    The name of the APIM instance
.PARAMETER apimrg
    The name of the APIM resource group
.PARAMETER api
    The name of the API
.PARAMETER openApiFile
    The location of the OpenAPI file to import
.PARAMETER apiVersion
    The ID of the api revision to create
.PARAMETER func
    The name of the function app
.INPUTS
    None
.OUTPUTS
    None
.NOTES
.EXAMPLE
#>

[CmdletBinding(SupportsShouldProcess)]
param
(
    [Parameter(Mandatory = $true)] [System.Object]$apim,
    [Parameter(Mandatory = $true)] [System.Object]$apimrg,
    [Parameter(Mandatory = $true)] [System.Object]$api,
    [Parameter(Mandatory = $true)] [System.Object]$openApiJson,
    [Parameter(Mandatory = $true)] [System.Object]$apiVersion,
    [Parameter(Mandatory = $true)] [System.Object]$func
)

Write-Output "get APIM context.. Started"
$apimContext = New-AzApiManagementContext -ResourceGroupName $apimrg -ServiceName $apim
Write-Output "get APIM context.. Completed"

Write-Output "Import API definition from file... Started"
Import-AzApiManagementApi `
    -Context $apimContext `
    -ApiId $api `
    -ApiRevision $apiVersion `
    -SpecificationFormat "OpenApi" `
    -SpecificationPath $openApiJson `
    -ServiceUrl "https://$func.azurewebsites.net" `
    -Path "pb/$api" `
Write-Output "Import API definition from file... Completed"

Set-AzApiManagmentApi -Context $apimContext -AppId $api -Name $api

