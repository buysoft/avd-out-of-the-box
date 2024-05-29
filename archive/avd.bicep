param location string = resourceGroup().location
param galleries_galautomationdev001_name string = 'galautomationdev001'

resource gallery 'Microsoft.Compute/galleries@2022-03-03' = {
  name: galleries_galautomationdev001_name
  location: location
  properties: {
    identifier: {}
  }
}

resource image 'Microsoft.Compute/galleries/images@2022-03-03' = {
  parent: gallery
  name: 'id-${galleries_galautomationdev001_name}'
  location: location
  properties: {
    hyperVGeneration: 'V2'
    architecture: 'x64'
    osType: 'Windows'
    osState: 'Generalized'
    identifier: {
      publisher: 'MicrosoftWindowsDesktop'
      offer: 'office-365'
      sku: 'win11-23h2-avd-m365'
    }
    recommended: {
      vCPUs: {
        min: 2
        max: 16
      }
      memory: {
        min: 2
        max: 32
      }
    }
    disallowed: {
      diskTypes: [
        'Premium_LRS'
      ]
    }
  }
}
