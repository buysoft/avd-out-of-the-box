@description('The base URI where artifacts required by this template are located.')
param artifactsLocation string

@description('The availability option for the VMs.')
@allowed([
  'None'
  'AvailabilitySet'
  'AvailabilityZone'
])
param availabilityOption string = 'AvailabilityZone'

// @description('The name of availability set to be used when create the VMs.')
// param availabilitySetName string = ''

@description('The availability zones to equally distribute VMs amongst')
param availabilityZones array = [
  '1'
  '2'
  '3'
]

// @description('(Required when vmImageType = Gallery) Gallery image Offer.')
// param vmGalleryImageOffer string = ''
// 
// @description('(Required when vmImageType = Gallery) Gallery image Publisher.')
// param vmGalleryImagePublisher string = ''
// 
// @description('Whether the VM image has a plan or not')
// param vmGalleryImageHasPlan bool = false
// 
// @description('(Required when vmImageType = Gallery) Gallery image SKU.')
// param vmGalleryImageSKU string = ''
// 
// @description('(Required when vmImageType = Gallery) Gallery image version.')
// param vmGalleryImageVersion string = ''

@description('This prefix will be used in combination with the VM number to create the VM name. This value includes the dash, so if using “rdsh” as the prefix, VMs would be named “rdsh-0”, “rdsh-1”, etc. You should use a unique prefix to reduce name collisions in Active Directory.')
param rdshPrefix string = take(toLower(resourceGroup().name), 10)

@description('Number of session hosts that will be created and added to the hostpool.')
param rdshNumberOfInstances int = 1

@description('The VM disk type for the VM: HDD or SSD.')
@allowed([
  'Premium_LRS'
  'StandardSSD_LRS'
  'Standard_LRS'
])
param rdshVMDiskType string = 'StandardSSD_LRS'

@description('The size of the session host VMs.')
param rdshVmSize string = 'Standard_A2'

@description('The size of the disk on the vm in GB')
param rdshVmDiskSizeGB int = 0

@description('Whether or not the VM is hibernate enabled')
param rdshHibernate bool = false

@description('Enables Accelerated Networking feature, notice that VM size must support it, this is supported in most of general purpose and compute-optimized instances with 2 or more vCPUs, on instances that supports hyperthreading it is required minimum of 4 vCPUs.')
param enableAcceleratedNetworking bool = false

@description('The username for the domain admin.')
param domainAdminUsername string

@description('The password that corresponds to the existing domain username.')
@secure()
param domainAdminPassword string

@description('A username to be used as the virtual machine administrator account. The vmLocalUsername and  vmLocalPassword parameters must both be provided. Otherwise, domain administrator credentials provided by administratorAccountUsername and domainAdminPassword will be used.')
param vmLocalUsername string = 'localadmin'

@description('The password associated with the virtual machine administrator account. The vmLocalUsername and  vmLocalPassword parameters must both be provided. Otherwise, domain administrator credentials provided by administratorAccountUsername and domainAdminPassword will be used.')
@secure()
param vmLocalPassword string = ''

// @description('The URL to store unmanaged disks.')
// param vhds string

@description('The unique id of the subnet for the nics.')
param subnetId string

// @description('The unique id of the load balancer backend pool id for the nics.')
// param loadBalancerBackendPoolId string = ''

param galleryName string
param galleryImageName string
param galleryImageVersion string

// // Resource IDs
// var galleryId = resourceId('Microsoft.Compute/galleries', galleryName)
// var galleryImageId = resourceId('Microsoft.Compute/galleries/images', galleryName, galleryImageName)
// 
// // Get all image versions
// var imageVersions = listGalleryImageVersions(galleryImageId, location)
// 
// // Sort the image versions and select the latest
// var latestImageVersion = array(max(imageVersions.value))

resource test1 'Microsoft.Compute/galleries@2023-07-03' existing = {
  name: galleryName
}

resource test2 'Microsoft.Compute/galleries/images@2023-07-03' existing = {
  parent: test1
  name: galleryImageName
}

@description('Resource ID of the image.')
var rdshImageSourceId = test2.id

@description('Location for all resources to be created in.')
param location string = ''

@description('The EdgeZone extended location of the session host VMs.')
param extendedLocation object = {}

// @description('Whether to create a new network security group or use an existing one')
// param createNetworkSecurityGroup bool = false
// 
// @description('The resource id of an existing network security group')
// param networkSecurityGroupId string = ''
// 
// @description('The rules to be given to the new network security group')
// param networkSecurityGroupRules array = []

@description('The tags to be assigned to the network interfaces')
param networkInterfaceTags object = {}

// @description('The tags to be assigned to the network security groups')
// param networkSecurityGroupTags object = {}

@description('The tags to be assigned to the virtual machines')
param virtualMachineTags object = {}

// @description('The tags to be assigned to the images')
// param imageTags object = {}

@description('VM name prefix initial number.')
param vmInitialNumber int = 0
// param _guidValue string = newGuid()

@description('The token for adding VMs to the hostpool')
@secure()
param hostpoolToken string

@description('The name of the hostpool')
param hostpoolName string

@description('OUPath for the domain join')
param ouPath string = ''

@description('Domain to join')
param domain string = ''

@description('IMPORTANT: You can use this parameter for the test purpose only as AAD Join is public preview. True if AAD Join, false if AD join')
param aadJoin bool = false

@description('IMPORTANT: Please don\'t use this parameter as intune enrollment is not supported yet. True if intune enrollment is selected.  False otherwise')
param intune bool = false

@description('Boot diagnostics object taken as body of Diagnostics Profile in VM creation')
param bootDiagnostics object = {
  enabled: false
}

@description('The name of user assigned identity that will assigned to the VMs. This is an optional parameter.')
param userAssignedIdentity string = ''

// @description('The PowerShell script URL to be run as part of post update custom configuration')
// param customConfigurationScriptUrl string = ''

@description('Session host configuration version of the host pool.')
param SessionHostConfigurationVersion string = ''

@description('System data is used for internal purposes, such as support preview features.')
param systemData object = {}

@description('Specifies the SecurityType of the virtual machine. It is set as TrustedLaunch to enable UefiSettings. Default: UefiSettings will not be enabled unless this property is set as TrustedLaunch.')
@allowed([
  'Standard'
  'TrustedLaunch'
  'ConfidentialVM'
])
param securityType string = 'Standard'

@description('Specifies whether secure boot should be enabled on the virtual machine.')
param secureBoot bool = false

@description('Specifies whether vTPM (Virtual Trusted Platform Module) should be enabled on the virtual machine.')
param vTPM bool = false

@description('Specifies whether integrity monitoring will be added to the virtual machine.')
param integrityMonitoring bool = true

@description('Managed disk security encryption type.')
@allowed([
  'VMGuestStateOnly'
  'DiskWithVMGuestState'
])
param managedDiskSecurityEncryptionType string = 'VMGuestStateOnly'

var emptyArray = []
var domainJoinName = ((domain == '') ? last(split(domainAdminUsername, '@')) : domain)
var storageAccountType = rdshVMDiskType
// var newNsgName = '${rdshPrefix}nsg-${_guidValue}'
// var newNsgDeploymentName = 'NSG-linkedTemplate-${_guidValue}'
// var nsgId = (createNetworkSecurityGroup ? resourceId('Microsoft.Network/networkSecurityGroups', newNsgName) : networkSecurityGroupId)
var isVMAdminAccountCredentialsProvided = ((vmLocalUsername != '') && (vmLocalPassword != ''))
var vmAdministratorUsername = (isVMAdminAccountCredentialsProvided ? vmLocalUsername : first(split(domainAdminUsername, '@')))
var vmAdministratorPassword = (isVMAdminAccountCredentialsProvided ? vmLocalPassword : domainAdminPassword)
// var vmAvailabilitySetResourceId = {
//   id: resourceId('Microsoft.Compute/availabilitySets/', availabilitySetName)
// }
// var planInfoEmpty = (empty(vmGalleryImageSKU) || empty(vmGalleryImagePublisher) || empty(vmGalleryImageOffer))
// var marketplacePlan = {
//   name: vmGalleryImageSKU
//   publisher: vmGalleryImagePublisher
//   product: vmGalleryImageOffer
// }
// var vmPlan = ((planInfoEmpty || (!vmGalleryImageHasPlan)) ? null : marketplacePlan)
var vmIdentityType = (aadJoin ? ((!empty(userAssignedIdentity)) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned') : ((!empty(userAssignedIdentity)) ? 'UserAssigned' : 'None'))
var vmIdentityTypeProperty = {
  type: vmIdentityType
}
var vmUserAssignedIdentityProperty = {
  userAssignedIdentities: {
    '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities/', userAssignedIdentity)}': {}
  }
}
var vmIdentity = ((!empty(userAssignedIdentity)) ? union(vmIdentityTypeProperty, vmUserAssignedIdentityProperty) : vmIdentityTypeProperty)
// var powerShellScriptName = (empty(customConfigurationScriptUrl) ? null : last(split(customConfigurationScriptUrl, '/')))
var securityProfile = {
  uefiSettings: {
    secureBootEnabled: secureBoot
    vTpmEnabled: vTPM
  }
  securityType: securityType
}
var managedDiskSecurityProfile = {
  securityEncryptionType: managedDiskSecurityEncryptionType
}
var countOfSelectedAZ = length(availabilityZones)
// var loadBalancerBackendPoolIdArray = [
//   {
//     id: loadBalancerBackendPoolId
//   }
// ]
// var loadBalancerBackendAddressPools = (empty(loadBalancerBackendPoolId) ? json('null') : loadBalancerBackendPoolIdArray)

resource rdshPrefix_vmInitialNumber_nic 'Microsoft.Network/networkInterfaces@2023-09-01' = [for i in range(0, rdshNumberOfInstances): {
  name: '${rdshPrefix}${(i + vmInitialNumber)}-nic'
  location: location
  extendedLocation: (empty(extendedLocation) ? null : extendedLocation)
  tags: networkInterfaceTags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
          // loadBalancerBackendAddressPools: loadBalancerBackendAddressPools
        }
      }
    ]
    enableAcceleratedNetworking: enableAcceleratedNetworking
    // networkSecurityGroup: (empty(networkSecurityGroupId) ? null : json('{"id": "${nsgId}"}'))
  }
  // dependsOn: [
  //   newNsgDeployment
  // ]
}]

resource rdshPrefix_vmInitialNumber 'Microsoft.Compute/virtualMachines@2023-09-01' = [for i in range(0, rdshNumberOfInstances): {
  name: '${rdshPrefix}${(i + vmInitialNumber)}'
  location: location
  extendedLocation: (empty(extendedLocation) ? null : extendedLocation)
  tags: virtualMachineTags
  // plan: vmPlan
  identity: vmIdentity
  properties: {
    hardwareProfile: {
      vmSize: rdshVmSize
    }
    // availabilitySet: ((availabilityOption == 'AvailabilitySet') ? vmAvailabilitySetResourceId : null)
    osProfile: {
      computerName: '${rdshPrefix}${(i + vmInitialNumber)}'
      adminUsername: vmAdministratorUsername
      adminPassword: vmAdministratorPassword
    }
    securityProfile: (((securityType == 'TrustedLaunch') || (securityType == 'ConfidentialVM')) ? securityProfile : null)
    storageProfile: {
      imageReference: {
        id: '${rdshImageSourceId}/versions/${galleryImageVersion}'
      }
      osDisk: {
        createOption: 'FromImage'
        diskSizeGB: ((rdshVmDiskSizeGB == 0) ? null : rdshVmDiskSizeGB)
        managedDisk: {
          storageAccountType: storageAccountType
          securityProfile: ((securityType == 'ConfidentialVM') ? managedDiskSecurityProfile : null)
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${rdshPrefix}${(i + vmInitialNumber)}-nic')
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: bootDiagnostics
    }
    additionalCapabilities: {
      hibernationEnabled: rdshHibernate
    }
    licenseType: 'Windows_Client'
  }
  zones: ((availabilityOption == 'AvailabilityZone') ? array(availabilityZones[(i % countOfSelectedAZ)]) : emptyArray)
  dependsOn: [
    rdshPrefix_vmInitialNumber_nic
  ]
}]

resource rdshPrefix_vmInitialNumber_GuestAttestation 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = [for i in range(0, rdshNumberOfInstances): if (integrityMonitoring) {
  name: '${rdshPrefix}${(i + vmInitialNumber)}/GuestAttestation'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Security.WindowsAttestation'
    type: 'GuestAttestation'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    settings: {
      AttestationConfig: {
        MaaSettings: {
          maaEndpoint: ''
          maaTenantName: 'GuestAttestation'
        }
        AscSettings: {
          ascReportingEndpoint: ''
          ascReportingFrequency: ''
        }
        useCustomToken: 'false'
        disableAlerts: 'false'
      }
    }
  }
  dependsOn: [
    rdshPrefix_vmInitialNumber
  ]
}]

resource rdshPrefix_vmInitialNumber_Microsoft_PowerShell_DSC 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = [for i in range(0, rdshNumberOfInstances): {
  name: '${rdshPrefix}${(i + vmInitialNumber)}/Microsoft.PowerShell.DSC'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.73'
    autoUpgradeMinorVersion: true
    settings: {
      modulesUrl: artifactsLocation
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      properties: {
        hostPoolName: hostpoolName
        registrationInfoTokenCredential: {
          UserName: 'PLACEHOLDER_DO_NOT_USE'
          Password: 'PrivateSettingsRef:RegistrationInfoToken'
        }
        aadJoin: aadJoin
        UseAgentDownloadEndpoint: true
        aadJoinPreview: (contains(systemData, 'aadJoinPreview') && systemData.aadJoinPreview)
        mdmId: (intune ? '0000000a-0000-0000-c000-000000000000' : '')
        sessionHostConfigurationLastUpdateTime: SessionHostConfigurationVersion
      }
    }
    protectedSettings: {
      Items: {
        RegistrationInfoToken: hostpoolToken
      }
    }
  }
  dependsOn: [
    rdshPrefix_vmInitialNumber_GuestAttestation
  ]
}]

@description('Entra ID / Azure Active Directory, The AAD login extension for the VMs.')
resource rdshPrefix_vmInitialNumber_AADLoginForWindows 'Microsoft.Compute/virtualMachines/extensions@2021-07-01' = [for i in range(0, rdshNumberOfInstances): if (aadJoin && (contains(systemData, 'aadJoinPreview') ? (!systemData.aadJoinPreview) : bool('true'))) {
  name: '${rdshPrefix}${(i + vmInitialNumber)}/AADLoginForWindows'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: 'AADLoginForWindows'
    typeHandlerVersion: '2.0'
    autoUpgradeMinorVersion: true
    settings: (intune ? {
      mdmId: '0000000a-0000-0000-c000-000000000000'
    } : null)
  }
  dependsOn: [
    rdshPrefix_vmInitialNumber_Microsoft_PowerShell_DSC
  ]
}]

@description('Active Directory, The domain join extension for the VMs.')
resource rdshPrefix_vmInitialNumber_joindomain 'Microsoft.Compute/virtualMachines/extensions@2021-07-01' = [for i in range(0, rdshNumberOfInstances): if (!aadJoin) {
  name: '${rdshPrefix}${(i + vmInitialNumber)}/joindomain'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      name: domainJoinName
      ouPath: ouPath
      user: domainAdminUsername
      restart: 'true'
      options: '3'
    }
    protectedSettings: {
      password: domainAdminPassword
    }
  }
  dependsOn: [
    rdshPrefix_vmInitialNumber_Microsoft_PowerShell_DSC
  ]
}]

// resource rdshPrefix_vmInitialNumber_Microsoft_Compute_CustomScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = [for i in range(0, rdshNumberOfInstances): if (!empty(customConfigurationScriptUrl)) {
//   name: '${rdshPrefix}${(i + vmInitialNumber)}/Microsoft.Compute.CustomScriptExtension'
//   location: location
//   properties: {
//     publisher: 'Microsoft.Compute'
//     type: 'CustomScriptExtension'
//     typeHandlerVersion: '1.10'
//     autoUpgradeMinorVersion: true
//     protectedSettings: {
//       fileUris: [
//         customConfigurationScriptUrl
//       ]
//       commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File ${powerShellScriptName}'
//     }
//   }
//   dependsOn: [
//     rdshPrefix_vmInitialNumber_Microsoft_PowerShell_DSC
//     rdshPrefix_vmInitialNumber_AADLoginForWindows
//     rdshPrefix_vmInitialNumber_joindomain
//   ]
// }]
