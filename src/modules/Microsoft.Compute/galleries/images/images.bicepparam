using './images.bicep'

param newOrExisting = 'new'
param galleryName = ''
param vmImageDefinitionName = ''
param hyperVGeneration = 'V2'
param architecture = 'x64'
param osType = 'Windows'
param osState = 'Generalized'
param identifier = {
  publisher: 'MicrosoftWindowsDesktop'
  offer: 'office-365'
  sku: 'win11-23h2-avd-m365'
}
param recommended = {
  vCPUs: {
    min: 2
    max: 16
  }
  memory: {
    min: 2
    max: 32
  }
}
param disallowed = {
  diskTypes: [
    'Premium_LRS'
  ]
}

