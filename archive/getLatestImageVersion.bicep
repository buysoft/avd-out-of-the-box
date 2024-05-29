// Parameters
param location string = resourceGroup().location
param galleryName string = 'galautomationdev001'
param galleryImageName string = 'id-galautomationdev001'
param galleryImageVersion string = 'latest'

// // Resource IDs
// var galleryId = resourceId('Microsoft.Compute/galleries', galleryName)
// var galleryImageId = resourceId('Microsoft.Compute/galleries/images', galleryName, galleryImageName)
// 
// // Get all image versions
// var imageVersions = listGalleryImageVersions(galleryImageId, location)
// 
// // Sort the image versions and select the latest
// var latestImageVersion = array(max(imageVersions.value))

resource test 'Microsoft.Compute/galleries/images@2023-07-03' existing = {
  name: galleryImageName
}

var imageVersions = listGalleryImageVersions(test.id, location).value

output name object = imageVersions
