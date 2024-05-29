param imageTemplateName string = 'avd11ImageTemplate02'
param svclocation string = resourceGroup().location
param userAssignedIdentityId string

@description('The resource group where the image will be staged, this must be a resource group not being blocked by Azure Policies.')
param stagingResourceGroupName string

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2023-07-01' = {
  name: imageTemplateName
  location: svclocation
  tags: {
    imagebuilderTemplate: 'AzureImageBuilderSIG'
    userIdentity: 'enabled'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityId}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 120
    stagingResourceGroup: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${stagingResourceGroupName}'
    vmProfile: {
      vmSize: 'Standard_DS2_v2'
      osDiskSizeGB: 127
    }
    source: {
      type: 'PlatformImage'
      publisher: 'MicrosoftWindowsDesktop'
      offer: 'office-365'
      sku: 'win11-23h2-avd-m365'
      version: 'latest'
    }
    customize: [
      {
        type: 'PowerShell'
        inline: [
          loadTextContent('install-office.ps1')
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
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: resourceId('Microsoft.Compute/galleries/images','id-galautomationdev001')
        // galleryImageId: '/subscriptions/4244f0c4-0776-47a7-a422-885726a8c7b6/resourceGroups/rg-sharedimagegallery-dev-001/providers/Microsoft.Compute/galleries/galautomationdev001/images/id-galautomationdev001'
        runOutputName: 'vg3vt3hbwnhs3hn43whn3n3'
        artifactTags: {
          source: 'wvd10'
          baseosimg: 'windows10'
        }
        replicationRegions: [
          'westeurope'
        ]
      }
    ]
  }
  dependsOn: []
}
