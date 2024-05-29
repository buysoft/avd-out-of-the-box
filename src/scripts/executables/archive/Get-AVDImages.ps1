# Pre-filled image information
$location       = "westeurope"
$publishersName = "MicrosoftWindowsDesktop"
$offerName      = "office-365"
$imageSKU       = "win11-23h2-avd-m365"

## Get all Publishers
$publishers = Get-AzVMImagePublisher -Location $location | Select-Object PublisherName

## Get all Image Offers from Publisher
$imageOffers = Get-AzVMImageOffer -Location $location -PublisherName $publishersName | Select-Object Offer

## Get all Image Skus from Offer
$imageSKUs = Get-AzVMImageSku -Location $location -PublisherName $publishersName -Offer $offerName | Select-Object Skus

