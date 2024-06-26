@description('The base URI where artifacts required by this template are located.')
param nestedTemplatesLocation string = 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/ARM-wvd-templates/nestedtemplates/'

@description('The base URI where artifacts required by this template are located.')
param artifactsLocation string = 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/ARM-wvd-templates/DSC/Configuration.zip'

@description('The name of the Hostpool to be created.')
param hostpoolName string

@description('The token of the host pool where the session hosts will be added.')
@secure()
param hostpoolToken string

@description('The resource group of the host pool to be updated. Used when the host pool was created empty.')
param hostpoolResourceGroup string = ''

@description('The location of the host pool to be updated. Used when the host pool was created empty.')
param hostpoolLocation string = ''

@description('The properties of the Hostpool to be updated. Used when the host pool was created empty.')
param hostpoolProperties object = {}

@description('The host pool VM template. Used when the host pool was created empty.')
param vmTemplate string = ''

@description('A username in the domain that has privileges to join the session hosts to the domain. For example, \'vmjoiner@contoso.com\'.')
param administratorAccountUsername string = ''

@description('The password that corresponds to the existing domain username.')
@secure()
param administratorAccountPassword string = ''

@description('A username to be used as the virtual machine administrator account. The vmAdministratorAccountUsername and  vmAdministratorAccountPassword parameters must both be provided. Otherwise, domain administrator credentials provided by administratorAccountUsername and administratorAccountPassword will be used.')
param vmAdministratorAccountUsername string = ''

@description('The password associated with the virtual machine administrator account. The vmAdministratorAccountUsername and  vmAdministratorAccountPassword parameters must both be provided. Otherwise, domain administrator credentials provided by administratorAccountUsername and administratorAccountPassword will be used.')
@secure()
param vmAdministratorAccountPassword string = ''

@description('Select the availability options for the VMs.')
@allowed([
  'None'
  'AvailabilitySet'
  'AvailabilityZone'
])
param availabilityOption string = 'None'

@description('The name of avaiability set to be used when create the VMs.')
param availabilitySetName string = ''

@description('Whether to create a new availability set for the VMs.')
param createAvailabilitySet bool = false

@description('The platform update domain count of avaiability set to be created.')
@allowed([
  1
  2
  3
  4
  5
  6
  7
  8
  9
  10
  11
  12
  13
  14
  15
  16
  17
  18
  19
  20
])
param availabilitySetUpdateDomainCount int = 5

@description('The platform fault domain count of avaiability set to be created.')
@allowed([
  1
  2
  3
])
param availabilitySetFaultDomainCount int = 2

@description('The availability zones to equally distribute VMs amongst')
param availabilityZones array = []

@description('The resource group of the session host VMs.')
param vmResourceGroup string

@description('The location of the session host VMs.')
param vmLocation string

@description('The edge zone of the session host VMs.')
param vmEdgeZone string = ''

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

@description('Select the image source for the session host vms. VMs from a Gallery image will be created with Managed Disks.')
@allowed([
  'CustomImage'
  'Gallery'
])
param vmImageType string = 'Gallery'

@description('(Required when vmImageType = Gallery) Gallery image Offer.')
param vmGalleryImageOffer string = ''

@description('(Required when vmImageType = Gallery) Gallery image Publisher.')
param vmGalleryImagePublisher string = ''

@description('(Required when vmImageType = Gallery) Gallery image SKU.')
param vmGalleryImageSKU string = ''

@description('(Required when vmImageType = Gallery) Gallery image version.')
param vmGalleryImageVersion string = ''

@description('Whether the VM has plan or not')
param vmGalleryImageHasPlan bool = false

@description('(Required when vmImageType = CustomImage) Resource ID of the image')
param vmCustomImageSourceId string = ''

@description('The VM disk type for the VM: HDD or SSD.')
@allowed([
  'UltraSSD_LRS'
  'Premium_LRS'
  'StandardSSD_LRS'
  'Standard_LRS'
])
param vmDiskType string

@description('The name of the virtual network the VMs will be connected to.')
param existingVnetName string

@description('The subnet the VMs will be placed in.')
param existingSubnetName string

@description('The resource group containing the existing virtual network.')
param virtualNetworkResourceGroupName string

@description('Whether to create a new network security group or use an existing one')
param createNetworkSecurityGroup bool = false

@description('The resource id of an existing network security group')
param networkSecurityGroupId string = ''

@description('The rules to be given to the new network security group')
param networkSecurityGroupRules array = []

@description('The tags to be assigned to the availability set')
param availabilitySetTags object = {}

@description('The tags to be assigned to the network interfaces')
param networkInterfaceTags object = {}

@description('The tags to be assigned to the network security groups')
param networkSecurityGroupTags object = {}

@description('The tags to be assigned to the virtual machines')
param virtualMachineTags object = {}

@description('The tags to be assigned to the images')
param imageTags object = {}

@description('GUID for the deployment')
param deploymentId string = ''

@description('WVD api version')
param apiVersion string = '2019-12-10-preview'

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

@description('ARM template that contains custom configurations to be run after the virtual machines are created.')
param customConfigurationTemplateUrl string = ''

@description('Url to the ARM template parameter file for the customConfigurationTemplateUrl parameter. This input will be used when the template is ran after the VMs have been deployed.')
param customConfigurationParameterUrl string = ''

@description('System data is used for internal purposes, such as support preview features.')
param systemData object = {}

@description('Specifies the SecurityType of the virtual machine. It is set as TrustedLaunch to enable UefiSettings. Default: UefiSettings will not be enabled unless this property is set as TrustedLaunch.')
param securityType string = ''

@description('Specifies whether secure boot should be enabled on the virtual machine.')
param secureBoot bool = false

@description('Specifies whether vTPM (Virtual Trusted Platform Module) should be enabled on the virtual machine.')
param vTPM bool = false

var rdshPrefix = '${vmNamePrefix}-'
var vhds = 'vhds/${rdshPrefix}'
var subnet_id = resourceId(virtualNetworkResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', existingVnetName, existingSubnetName)
var vmTemplateName = 'managedDisks-${toLower(replace(vmImageType, ' ', ''))}vm'
var vmTemplateUri = '${nestedTemplatesLocation}${vmTemplateName}.json'
var rdshVmNamesOutput = {
  rdshVmNamesCopy: [for j in range(0, vmNumberOfInstances): {
    name: concat(rdshPrefix, (vmInitialNumber + j))
  }]
}

module UpdateHostPool_deploymentId './nested_UpdateHostPool_deploymentId.bicep' = if (!empty(hostpoolResourceGroup)) {
  name: 'UpdateHostPool-${deploymentId}'
  scope: resourceGroup(hostpoolResourceGroup)
  params: {
    hostpoolName: hostpoolName
    apiVersion: apiVersion
    hostpoolLocation: hostpoolLocation
    hostpoolProperties: hostpoolProperties
  }
}

module AVSet_linkedTemplate_deploymentId './nested_AVSet_linkedTemplate_deploymentId.bicep' = if ((availabilityOption == 'AvailabilitySet') && createAvailabilitySet) {
  name: 'AVSet-linkedTemplate-${deploymentId}'
  scope: resourceGroup(vmResourceGroup)
  params: {
    availabilitySetName: availabilitySetName
    vmLocation: vmLocation
    availabilitySetTags: availabilitySetTags
    availabilitySetUpdateDomainCount: availabilitySetUpdateDomainCount
    availabilitySetFaultDomainCount: availabilitySetFaultDomainCount
  }
  dependsOn: [
    UpdateHostPool_deploymentId
  ]
}

module vmCreation_linkedTemplate_deploymentId '?' /*TODO: replace with correct path to [variables('vmTemplateUri')]*/ = {
  name: 'vmCreation-linkedTemplate-${deploymentId}'
  scope: resourceGroup(vmResourceGroup)
  params: {
    artifactsLocation: artifactsLocation
    availabilityOption: availabilityOption
    availabilitySetName: availabilitySetName
    availabilityZones: availabilityZones
    vmGalleryImageOffer: vmGalleryImageOffer
    vmGalleryImagePublisher: vmGalleryImagePublisher
    vmGalleryImageHasPlan: vmGalleryImageHasPlan
    vmGalleryImageSKU: vmGalleryImageSKU
    vmGalleryImageVersion: vmGalleryImageVersion
    rdshPrefix: rdshPrefix
    rdshNumberOfInstances: vmNumberOfInstances
    rdshVMDiskType: vmDiskType
    rdshVmSize: vmSize
    rdshVmDiskSizeGB: vmDiskSizeGB
    rdshHibernate: vmHibernate
    enableAcceleratedNetworking: false
    vmAdministratorAccountUsername: vmAdministratorAccountUsername
    vmAdministratorAccountPassword: vmAdministratorAccountPassword
    administratorAccountUsername: administratorAccountUsername
    administratorAccountPassword: administratorAccountPassword
    'subnet-id': subnet_id
    vhds: vhds
    rdshImageSourceId: vmCustomImageSourceId
    location: vmLocation
    edgeZone: vmEdgeZone
    createNetworkSecurityGroup: createNetworkSecurityGroup
    networkSecurityGroupId: networkSecurityGroupId
    networkSecurityGroupRules: networkSecurityGroupRules
    networkInterfaceTags: networkInterfaceTags
    networkSecurityGroupTags: networkSecurityGroupTags
    virtualMachineTags: virtualMachineTags
    imageTags: imageTags
    vmInitialNumber: vmInitialNumber
    hostpoolName: hostpoolName
    hostpoolToken: hostpoolToken
    domain: domain
    ouPath: ouPath
    aadJoin: aadJoin
    intune: intune
    bootDiagnostics: bootDiagnostics
    _guidValue: deploymentId
    userAssignedIdentity: userAssignedIdentity
    customConfigurationTemplateUrl: customConfigurationTemplateUrl
    customConfigurationParameterUrl: customConfigurationParameterUrl
    SessionHostConfigurationVersion: (contains(systemData, 'hostpoolUpdate') ? systemData.sessionHostConfigurationVersion : '')
    systemData: systemData
    securityType: securityType
    secureBoot: secureBoot
    vTPM: vTPM
  }
  dependsOn: [
    AVSet_linkedTemplate_deploymentId
  ]
}

output rdshVmNamesObject object = rdshVmNamesOutput
