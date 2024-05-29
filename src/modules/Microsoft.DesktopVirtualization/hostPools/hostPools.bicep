// Parameters
param newOrExisting string = 'new'
param location string
param hostPoolName string
param friendlyName string
param hostPoolType string
param loadBalancerType string
param customRdpProperty string
param personalDesktopAssignmentType string
param maxSessionLimit int

// New
resource newHostPool 'Microsoft.DesktopVirtualization/hostPools@2023-09-05' = if (newOrExisting == 'new') {
  name: hostPoolName
  location: location
  properties: {
    friendlyName: friendlyName
    hostPoolType: hostPoolType
    loadBalancerType: loadBalancerType
    customRdpProperty: customRdpProperty
    preferredAppGroupType: 'Desktop'
    personalDesktopAssignmentType: personalDesktopAssignmentType
    maxSessionLimit: maxSessionLimit
    validationEnvironment: false
  }
}

// Existing
resource existingHostPool 'Microsoft.DesktopVirtualization/hostPools@2023-09-05' existing = if(newOrExisting == 'existing') {
  name: hostPoolName
}

// Output
output hostPool object = newOrExisting == 'new' ? newHostPool : existingHostPool
output id string = newOrExisting == 'new' ? newHostPool.id : existingHostPool.id
output name string = newOrExisting == 'new' ? newHostPool.name : existingHostPool.name
