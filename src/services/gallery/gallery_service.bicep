param location string = resourceGroup().location
param dateTime string = utcNow('yyyy-MM-ddTHH-mm-ssZ')

// Gallery and VM Image Definition Parameters
param galleryName string = 'galautomationdev001'


module gallery '../../modules/Microsoft.Compute/galleries/galleries.bicep' = {
  name: '${galleryName}-${dateTime}'
  params: {
    name: galleryName
    location: location
  }
}
