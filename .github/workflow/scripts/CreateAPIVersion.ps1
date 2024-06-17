
<#
.SYNOPSIS
    creates a new API revision.
.DESCRIPTION
    This script creates a new incremental API revision.
.PARAMETER apim
    The name of the APIM instance.
.PARAMETER apimrg
    The name of the APIM resource group.
.PARAMETER api
    The name of the API.
.PARAMETER apirevision
    The ID of the version to create.
.PARAMETER func
    The name of the function app.
.PARAMETER rg
    The name of the function app resource group.
.INPUTS
    None
.OUTPUTS
    None
.NOTES
.EXAMPLE
    CreateAPIVersion.ps1 -apim $apim -apimrg $apimrg -api $api -version ${{ Build.BuildId }}
#>

[CmdletBinding(SupportsShouldProcess)]
param
(
    [Parameter(Mandatory = $true)] [System.Object]$apim,
    [Parameter(Mandatory = $true)] [System.Object]$apimrg,
    [Parameter(Mandatory = $true)] [System.Object]$api,
    [Parameter(Mandatory = $true)] [System.Object]$apirevision,
    [Parameter(Mandatory = $true)] [System.Object]$func,
    [Parameter(Mandatory = $true)] [System.Object]$rg
)

Write-Output "APIM: $apim"
$apimContext = New-AzApiManagementContext -ResourceGroupName $apimrg -ServiceName $apim
Write-Output "Get APIM Context.. Completed"
$FunctionApp = Get-AzWebApp -ResourceGroupName $rg -Name $func
$DefaultHostName = $FunctionApp.DefaultHostName
Write-Output "Create API revision $apiRevision.. Started"
New-AzApiManagementApiRevision -Context $apimContext -ApiId $api -ApiRevision $apiRevision -ServiceUrl "https://$DefaultHostName"
Write-Output "Create API revision $apiRevision.. Completed"

Write-Output "Make Revision $apiRevision the current.. Started"
New-AzApiManagementApiRelease -Context $apimContext -ApiId $api -ApiRevision $apiRevision -Note "Automated release of revision $apiRevision"
Write-Output "Make Revision $apiRevision the current.. Completed"

