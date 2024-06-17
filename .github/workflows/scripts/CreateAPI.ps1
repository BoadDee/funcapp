
<#
.SYNOPSIS
    Create a new API project.
.DESCRIPTION
    This script creates a new API project.
.PARAMETER apim
    The name of the APIM instance.
.PARAMETER apimrg
    The name of the APIM resource group.
.PARAMETER api
    The name of the API.
.PARAMETER func
    The name of the function app.
.PARAMETER product
    The name of the product.
.INPUTS
    None
.OUTPUTS
    None
.NOTES
.EXAMPLE
    CreateAPI.ps1 -apim $apim -apimrg $apimrg -api $api -sta $storagAccount -product $product
#>

[CmdletBinding(SupportsShouldProcess)]
param
(
    [Parameter(Mandatory = $true)] [System.Object]$apim,
    [Parameter(Mandatory = $true)] [System.Object]$apimrg,
    [Parameter(Mandatory = $true)] [System.Object]$api,
    #[Parameter(Mandatory = $true)] [System.Object]$sta,
    #[Parameter(Mandatory = $true)] [System.Object]$staApi,
    [Parameter(Mandatory = $true)] [System.Object]$func,
    [Parameter(Mandatory = $true)] [System.Object]$product
)

Write-Output "APIM: $apim"
Write-Output "APIM RG: $apimrg"

Write-Output "Get APIM Context.. Started"
$apimContext = New-AzApiManagementContext -ResourceGroupName $apimrg -ServiceName $apim
Write-Output "Get APIM Context.. Completed"

Write-Output "Check list of all Products.. Started"
$products = (Get-AzApiManagementProduct -Context $apimContext).ProductId
Write-Output "Check list of all Products.. Completed"

if ($products -like $product) 
{
    Write-Output "Product $product already exists in $apim"
}

else
{
    Write-Output "Create Product $product in $apim.. Started"
    New-AzApiManagementProduct -Context $apimContext -ProductId $product -Title $product -SubscriptionRequired $true -ApprovalRequired $true -State 'published' 
    Write-Output "Create Product $product in $apim.. Completed"
}

Write-Output "Check list of all APIs.. Started"
$apis = (Get-AzApiManagementApi -Context $apimContext).Name
Write-Output "Check list of all APIs.. Completed"

if ($apis -like $api) 
{
    Write-Output "API $api already exists in $apim"
}

else
{
    Write-Output "Create API $api in $apim.. Started"
    New-AzApiManagementApi -Context $apimContext  -Name $api -ServiceUrl "https://$func.azurewebsites.net" -Protocols @("https") -Path "pb/$api" -ApiId $api -ProductId @($product)
    Write-Output "Create API $api in $apim.. Completed"
}

# if ($apis -like $staApi) 
# {
#     Write-Output "API $staApi already exists in $apim"
# }

# else
# {
#     Write-Output "Create API $staApi in $apim.. Started"
#     New-AzApiManagementApi -Context $apimContext  -Name $staApi -ServiceUrl "https://$sta.blob.core.windows.net/" -Protocols @("https") -Path "pb/$staApi" -ApiId $staApi -ProductId @($product)
#     Write-Output "Create API $staApi in $apim.. Completed"
# }