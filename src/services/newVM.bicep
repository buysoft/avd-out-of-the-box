// @description('The base URI where artifacts required by this template are located.')
// param nestedTemplatesLocation string

@description('The base URI where the Azure artifacts required by this template are located.')
param artifactsLocation string

// @description('The base URI where the Azure Stack HCI artifacts required by this template are located.')
// param hciArtifactsLocation string = ''

@description('The name of the Hostpool to be created.')
param hostpoolName string

@description('The token of the host pool where the session hosts will be added.')
@secure()
param hostpoolToken string

// @description('The resource group of the host pool to be updated. Used when the host pool was created empty.')
// param hostpoolResourceGroup string = ''
// 
// @description('The location of the host pool to be updated. Used when the host pool was created empty.')
// param hostpoolLocation string = ''
// 
// @description('The properties of the Hostpool to be updated. Used when the host pool was created empty.')
// param hostpoolProperties object = {}
// 
// @description('The host pool VM template. Used when the host pool was created empty.')
// param vmTemplate string = ''

@description('A username in the domain that has privileges to join the session hosts to the domain. For example, \'vmjoiner@contoso.com\'.')
param domainAdminUsername string = ''

@description('The password that corresponds to the existing domain username.')
@secure()
param domainAdminPassword string = ''

@description('A username to be used as the virtual machine administrator account. The vmLocalUsername and  vmLocalPassword parameters must both be provided. Otherwise, domain administrator credentials provided by domainAdminUsername and domainAdminPassword will be used.')
param vmLocalUsername string = ''

@description('The password associated with the virtual machine administrator account. The vmLocalUsername and  vmLocalPassword parameters must both be provided. Otherwise, domain administrator credentials provided by domainAdminUsername and domainAdminPassword will be used.')
@secure()
param vmLocalPassword string = ''

@description('Select the availability options for the VMs.')
@allowed([
  'None'
  'AvailabilitySet'
  'AvailabilityZone'
])
param availabilityOption string = 'AvailabilityZone'

// @description('The name of avaiability set to be used when create the VMs.')
// param availabilitySetName string = 'av-zone-${hostpoolName}'

// @description('Whether to create a new availability set for the VMs.')
// param createAvailabilitySet bool = false
// 
// @description('The platform update domain count of avaiability set to be created.')
// @allowed([
//   1
//   2
//   3
//   4
//   5
//   6
//   7
//   8
//   9
//   10
//   11
//   12
//   13
//   14
//   15
//   16
//   17
//   18
//   19
//   20
// ])
// param availabilitySetUpdateDomainCount int = 5
// 
// @description('The platform fault domain count of avaiability set to be created.')
// @allowed([
//   1
//   2
//   3
// ])
// param availabilitySetFaultDomainCount int = 2

@description('The availability zones to equally distribute VMs amongst')
param availabilityZones array = [
  '1'
  '2'
  '3'
]

@description('The resource group of the session host VMs.')
param vmResourceGroup string

@description('The location of the session host VMs.')
param vmLocation string

@description('The EdgeZone extended location of the session host VMs.')
param vmExtendedLocation object = {}

@description('The size of the session host VMs.')
param vmSize string

@description('The size of the session host VMs in GB. If the value of this parameter is 0, the disk will be created with the default size set in the image.')
param vmDiskSizeGB int = 0

@description('Whether the VMs created will be hibernate enabled')
param vmHibernate bool = false

@description('VM name prefix initial number.')
param vmInitialNumber int

@description('Number of session hosts that will be created and added to the hostpool.')
param vmNumberOfInstances int

@description('This prefix will be used in combination with the VM number to create the VM name. If using \'rdsh\' as the prefix, VMs would be named \'rdsh-0\', \'rdsh-1\', etc. You should use a unique prefix to reduce name collisions in Active Directory.')
param vmNamePrefix string

// @description('Select the image source for the session host vms. VMs from a Gallery image will be created with Managed Disks.')
// @allowed([
//   'CustomImage'
//   'Gallery'
// ])
// param vmImageType string = 'CustomImage'

// @description('(Required when vmImageType = Gallery) Gallery image Offer.')
// param vmGalleryImageOffer string = ''
// 
// @description('(Required when vmImageType = Gallery) Gallery image Publisher.')
// param vmGalleryImagePublisher string = ''
// 
// @description('(Required when vmImageType = Gallery) Gallery image SKU.')
// param vmGalleryImageSKU string = ''
// 
// @description('(Required when vmImageType = Gallery) Gallery image version.')
// param vmGalleryImageVersion string = ''
// 
// @description('Whether the VM has plan or not')
// param vmGalleryImageHasPlan bool = false

// @description('(Required when vmImageType = CustomImage) Resource ID of the image')
// param vmCustomImageSourceId string = ''

param galleryName string
param galleryImageName string
param galleryImageVersion string

@description('The VM disk type for the VM: HDD or SSD.')
@allowed([
  'Premium_LRS'
  'StandardSSD_LRS'
  'Standard_LRS'
])
param vmDiskType string = 'StandardSSD_LRS'

@description('The name of the virtual network the VMs will be connected to.')
param existingVnetName string = ''

@description('The subnet the VMs will be placed in.')
param existingSubnetName string = ''

@description('The resource group containing the existing virtual network.')
param virtualNetworkResourceGroupName string = ''

// @description('Whether to create a new network security group or use an existing one')
// param createNetworkSecurityGroup bool = false
// 
// @description('The resource id of an existing network security group')
// param networkSecurityGroupId string = ''
// 
// @description('The rules to be given to the new network security group')
// param networkSecurityGroupRules array = []
// 
// @description('The tags to be assigned to the availability set')
// param availabilitySetTags object = {}
// 
// @description('The tags to be assigned to the network interfaces')
// param networkInterfaceTags object = {}
// 
// @description('The tags to be assigned to the network security groups')
// param networkSecurityGroupTags object = {}

@description('The tags to be assigned to the virtual machines')
param virtualMachineTags object = {}

// @description('The tags to be assigned to the images')
// param imageTags object = {}

@description('GUID for the deployment')
param deploymentId string = guid('vmCreation')

// @description('WVD api version')
// param apiVersion string = '2019-12-10-preview'

@description('OUPath for the domain join')
param ouPath string = ''

@description('Domain to join')
param domain string = ''

@description('True if AAD Join, false if AD join')
param aadJoin bool = true

// @description('True if intune enrollment is selected.  False otherwise')
// param intune bool = false

@description('Boot diagnostics object taken as body of Diagnostics Profile in VM creation')
param bootDiagnostics object = {
  enabled: false
}

@description('The name of user assigned identity that will assigned to the VMs. This is an optional parameter.')
param userAssignedIdentity string = ''

// @description('PowerShell script URL to be run after the Virtual Machines are created.')
// param customConfigurationScriptUrl string = ''

@description('System data is used for internal purposes, such as support preview features.')
param systemData object = {}

@description('Specifies the SecurityType of the virtual machine. It is set as TrustedLaunch to enable UefiSettings. Default: UefiSettings will not be enabled unless this property is set as TrustedLaunch.')
@allowed([
  'Standard'
  'TrustedLaunch'
  'ConfidentialVM'
])
param securityType string = 'TrustedLaunch'

@description('Specifies whether secure boot should be enabled on the virtual machine.')
param secureBoot bool = false

@description('Specifies whether vTPM (Virtual Trusted Platform Module) should be enabled on the virtual machine.')
param vTPM bool = false

@description('Managed disk security encryption type.')
@allowed([
  'VMGuestStateOnly'
  'DiskWithVMGuestState'
])
param managedDiskSecurityEncryptionType string = 'VMGuestStateOnly'

@description('Specifies whether integrity monitoring will be added to the virtual machine.')
param integrityMonitoring bool = true

// @description('The infrastructure type for the virtual machines. Can be OnPremises or Cloud')
// @allowed([
//   'OnPremises'
//   'Cloud'
// ])
// param vmInfrastructureType string = 'Cloud'
// 
// @description('A deployment target created and customized by your organization for creating virtual machines. The custom location is associated to an Azure Stack HCI cluster. E.g., /subscriptions/<subscriptionID>/resourcegroups/Contoso-rg/providers/microsoft.extendedlocation/customlocations/Contoso-CL.')
// param customLocationId string = ''
// 
// @description('Full ARM resource ID of the AzureStackHCI virtual machine image used for the VMs. E.g., /subscriptions/<subscriptionID>/resourceGroups/Contoso-rg/providers/microsoft.azurestackhci/marketplacegalleryimages/Contoso-Win11image.')
// param hciImageId string = ''
// 
// @description('Full ARM resource ID of the AzureStackHCI virtual network used for the VMs. E.g., /subscriptions/<subscriptionID>/resourceGroups/Contoso-rg/providers/Microsoft.AzureStackHCI/virtualnetworks/Contoso-virtualnetwork.')
// param hciLogicalNetworkId string = ''
// 
// @description('Virtual Processor Count. Default is 4.')
// param virtualProcessorCount int = 4
// 
// @description('Memory in GB. Default is 8.')
// param memoryMB int = 8
// 
// @description('This parameter is optional and only used if dynamicMemory = true. When using dynamic memory this setting is the maximum GB given to the VM.')
// param maximumMemoryMB int = 0
// 
// @description('This parameter is optional and only used if dynamicMemory = true. When using dynamic memory this setting is the minimum GB given to the VM.')
// param minimumMemoryMB int = 0
// 
// @description('Dynamic memory for virtual machine from a range for amount of memory.')
// param dynamicMemoryConfig bool = false
// 
// @description('This parameter is optional and only used if dynamicMemory = true. When using dynamic memory this setting is the buffer of extra memory given to the VM.')
// param targetMemoryBuffer int = 20

// @description('This parameter is optional and is used when user choose a load balancer for edge zone case')
// param loadBalancerBackendPoolId string = ''

var rdshPrefix = '${vmNamePrefix}-'
// var vhds = 'vhds/${rdshPrefix}'
var subnetId = resourceId(subscription().subscriptionId ,virtualNetworkResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', existingVnetName, existingSubnetName)
// var vmTemplateName = 'managedDisks-${toLower(replace(vmImageType, ' ', ''))}vm'
// var vmTemplateUri = '${nestedTemplatesLocation}${vmTemplateName}.json'
// var azureStackHciTemplateUri = '${nestedTemplatesLocation}azurestackhci-vm.json'
// var rdshVmNamesOutput = {
//   rdshVmNamesCopy: [for j in range(0, vmNumberOfInstances): {
//     name: concat(rdshPrefix, (vmInitialNumber + j))
//   }]
// }

// module UpdateHostPool_deploymentId './nested_UpdateHostPool_deploymentId.bicep' = if (!empty(hostpoolResourceGroup)) {
//   name: 'UpdateHostPool-${deploymentId}'
//   scope: resourceGroup(hostpoolResourceGroup)
//   params: {
//     hostpoolName: hostpoolName
//     apiVersion: apiVersion
//     hostpoolLocation: hostpoolLocation
//     hostpoolProperties: hostpoolProperties
//   }
// }

module vmCreation_linkedTemplate_deploymentId 'newVMModule.bicep' = {
  name: 'vmCreation-linkedTemplate-${deploymentId}'
  scope: resourceGroup(vmResourceGroup)
  params: {
    artifactsLocation: artifactsLocation
    availabilityOption: availabilityOption
    // availabilitySetName: availabilitySetName
    availabilityZones: availabilityZones
    // vmGalleryImageOffer: vmGalleryImageOffer
    // vmGalleryImagePublisher: vmGalleryImagePublisher
    // vmGalleryImageHasPlan: vmGalleryImageHasPlan
    // vmGalleryImageSKU: vmGalleryImageSKU
    // vmGalleryImageVersion: vmGalleryImageVersion
    rdshPrefix: rdshPrefix
    rdshNumberOfInstances: vmNumberOfInstances
    rdshVMDiskType: vmDiskType
    rdshVmSize: vmSize
    rdshVmDiskSizeGB: vmDiskSizeGB
    rdshHibernate: vmHibernate
    enableAcceleratedNetworking: false
    vmLocalUsername: vmLocalUsername
    vmLocalPassword: vmLocalPassword
    domainAdminUsername: domainAdminUsername
    domainAdminPassword: domainAdminPassword
    subnetId: subnetId
    // loadBalancerBackendPoolId: loadBalancerBackendPoolId
    // vhds: vhds
    galleryName: galleryName
    galleryImageName: galleryImageName
    galleryImageVersion: galleryImageVersion
    location: vmLocation
    extendedLocation: vmExtendedLocation
    // createNetworkSecurityGroup: createNetworkSecurityGroup
    // networkSecurityGroupId: networkSecurityGroupId
    // networkSecurityGroupRules: networkSecurityGroupRules
    // networkInterfaceTags: networkInterfaceTags
    // networkSecurityGroupTags: networkSecurityGroupTags
    virtualMachineTags: virtualMachineTags
    // imageTags: imageTags
    vmInitialNumber: vmInitialNumber
    hostpoolName: hostpoolName
    hostpoolToken: hostpoolToken
    domain: domain
    ouPath: ouPath
    aadJoin: aadJoin
    bootDiagnostics: bootDiagnostics
    // _guidValue: deploymentId
    userAssignedIdentity: userAssignedIdentity
    // customConfigurationScriptUrl: customConfigurationScriptUrl
    systemData: systemData
    securityType: securityType
    secureBoot: secureBoot
    vTPM: vTPM
    managedDiskSecurityEncryptionType: managedDiskSecurityEncryptionType
    integrityMonitoring: integrityMonitoring
  }
}

// output rdshVmNamesObject object = rdshVmNamesOutput
