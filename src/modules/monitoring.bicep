// Parameters
param lawSubscription string
param lawResourceGroup string
param lawName string

param hostpoolName string
param workspaceName string
param appgroupName string

// Variables
var lawSub = empty(lawSubscription) ? subscription().subscriptionId : lawSubscription
var lawRG = empty(lawResourceGroup) ? resourceGroup().name : lawResourceGroup
var lawResourceName = lawName

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2023-09-05' existing = {
  name: hostpoolName
}

resource appGroup 'Microsoft.DesktopVirtualization/applicationGroups@2023-09-05' existing = {
  name: appgroupName
}

resource workspace 'Microsoft.DesktopVirtualization/workspaces@2023-09-05' existing = {
  name: workspaceName
}

resource hostpoolDiagName 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'hostpool-diag'
  scope: hostPool
  properties: {
    workspaceId: resourceId(lawSub, lawRG, 'Microsoft.OperationalInsights/workspaces', lawResourceName)
    logs: [
      {
        category: 'Checkpoint'
        enabled: true
      }
      {
        category: 'Error'
        enabled: true
      }
      {
        category: 'Management'
        enabled: true
      }
      {
        category: 'Connection'
        enabled: true
      }
      {
        category: 'HostRegistration'
        enabled: true
      }
      {
        category: 'AgentHealthStatus'
        enabled: true
      }
      {
        category: 'NetworkData'
        enabled: true
      }
      {
        category: 'SessionHostManagement'
        enabled: true
      }
    ]
  }
}

resource workspaceDiagName 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'workspacepool-diag'
  scope: workspace
  properties: {
    workspaceId: resourceId(lawSub, lawRG, 'Microsoft.OperationalInsights/workspaces', lawResourceName)
    logs: [
      {
        category: 'Checkpoint'
        enabled: true
      }
      {
        category: 'Error'
        enabled: true
      }
      {
        category: 'Management'
        enabled: true
      }
      {
        category: 'Feed'
        enabled: true
      }
    ]
  }
}

resource appGroupDiagName 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'appgroup-diag'
  scope: appGroup
  properties: {
    workspaceId: resourceId(lawSub, lawRG, 'Microsoft.OperationalInsights/workspaces', lawResourceName)
    logs: [
      {
        category: 'Checkpoint'
        enabled: true
      }
      {
        category: 'Error'
        enabled: true
      }
      {
        category: 'Management'
        enabled: true
      }
    ]
  }
}
