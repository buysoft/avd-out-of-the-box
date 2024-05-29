using './images_service.bicep'

param galleryName = 'galautomationdev001'
param vmImageDefinitionName = 'vmid-galautomationdev001'
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
param imageTemplateName = 'avd11ImageTemplate02'
param gallerImageSubscription = '11111111-1111-1111-1111-111111111111'
param galleryImageResourceGroup = 'rg-avd-staging'
param galleryImageName = 'gal-avd11ImageTemplate02'
param userAssignedIdentityId = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-avd-staging/providers/Microsoft.ManagedIdentity/userAssignedIdentities/avd-image-template-identity'
param stagingResourceGroupName = 'rg-avd-staging'
param buildTimeoutInMinutes = 120
param vmSize = 'Standard_D4s_v3'
param osDiskSizeGB = 128
param source = {
  type: 'PlatformImage'
  publisher: 'MicrosoftWindowsDesktop'
  offer: 'office-365'
  sku: 'win11-23h2-avd-m365'
  version: 'latest'
}
param replicationRegions = [
  'westeurope'
]
param customize = [
  {
    type: 'PowerShell'
    inline: [
      loadTextContent('../../scripts/software/install-office.ps1')
    ]
    runAsSystem: true
    runElevated: true
  }
  {
    name: 'avdBuiltInScript_removeAppxPackages'
    type: 'File'
    destination: 'C:\\AVDImage\\removeAppxPackages.ps1'
    sourceUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/RemoveAppxPackages.ps1'
  }
  {
    name: 'avdBuiltInScript_removeAppxPackages-parameter'
    type: 'PowerShell'
    inline: [
      'C:\\AVDImage\\removeAppxPackages.ps1 -AppxPackages "Microsoft.BingNews","Microsoft.BingWeather","Microsoft.GamingApp","Microsoft.MicrosoftOfficeHub","Microsoft.MicrosoftSolitaireCollection","Microsoft.MicrosoftStickyNotes","Microsoft.People","Microsoft.ScreenSketch","Microsoft.SkypeApp","Microsoft.WindowsAlarms","Microsoft.WindowsCamera","Microsoft.windowscommunicationsapps","Microsoft.WindowsMaps","Microsoft.WindowsFeedbackHub","Microsoft.Xbox.TCUI","Microsoft.XboxGameOverlay","Microsoft.XboxGamingOverlay","Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay","Microsoft.YourPhone","Microsoft.ZuneMusic","Microsoft.ZuneVideo","Microsoft.XboxApp"'
    ]
    runAsSystem: true
    runElevated: true
  }
  {
    name: 'avdBuiltInScript_timeZoneRedirection'
    type: 'PowerShell'
    scriptUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/TimezoneRedirection.ps1'
    runAsSystem: true
    runElevated: true
  }
  {
    name: 'avdBuiltInScript_optimizations'
    type: 'File'
    destination: 'C:\\AVDImage\\WindowsOptimization.ps1'
    sourceUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/WindowsOptimization.ps1'
  }
  {
    name: 'avdBuiltInScript_optimizations-parameter'
    type: 'PowerShell'
    inline: [
      'C:\\AVDImage\\WindowsOptimization.ps1 -Optimizations "All"'
    ]
    runAsSystem: true
    runElevated: true
  }
  {
    name: 'RestartAfterOptimizations'
    type: 'WindowsRestart'
    restartCheckCommand: 'echo Restarting'
    restartTimeout: '10m'
  }
  {
    name: 'ApplyWindowsUpdates'
    type: 'WindowsUpdate'
    searchCriteria: 'IsInstalled=0'
  }
  {
    name: 'RestartAfterUpdates'
    type: 'WindowsRestart'
    restartCheckCommand: 'echo Restarting'
    restartTimeout: '15m'
  }
  {
    name: 'ApplyWindowsUpdates'
    type: 'WindowsUpdate'
    searchCriteria: 'IsInstalled=0'
  }
  {
    name: 'RestartAfterUpdates'
    type: 'WindowsRestart'
    restartCheckCommand: 'echo Restarting'
    restartTimeout: '15m'
  }
  {
    name: 'avdBuiltInScript_disableAutoUpdates'
    type: 'PowerShell'
    scriptUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/DisableAutoUpdates.ps1'
    runAsSystem: true
    runElevated: true
  }
] 

