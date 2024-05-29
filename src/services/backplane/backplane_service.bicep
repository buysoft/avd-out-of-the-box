param location string

param hostPoolName string
param friendlyName string


module hostPool '../../modules/Microsoft.DesktopVirtualization/hostPools/hostPools.bicep' = {
  name: 'hostPool'
  params: {
    location: location
    hostPoolName: hostPoolName
    friendlyName: friendlyName
    customRdpProperty:
  }
}
