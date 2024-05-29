// Parameters
param newOrExistingHostPool string = 'new'
param diagnosticSettingsName string
param logs array

param lawSubscription string
param lawResourceGroup string
param lawName string

// Variables
var lawSub = empty(lawSubscription) ? subscription().subscriptionId : lawSubscription
var lawRG = empty(lawResourceGroup) ? resourceGroup().name : lawResourceGroup
var lawResourceName = lawName

// New
resource newDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (newOrExistingHostPool == 'new') {
  name: diagnosticSettingsName
  properties: {
    workspaceId: resourceId(lawSub, lawRG, 'Microsoft.OperationalInsights/workspaces', lawResourceName)
    logs: logs
  }
}

// Existing
resource existingDiagnosticSettings 'Microsoft.DesktopVirtualization/applicationGroups@2023-09-05' existing = if(newOrExistingHostPool == 'existing') {
  name: diagnosticSettingsName
}

// Output
output applicationGroup object = newOrExistingHostPool == 'new' ? newDiagnosticSettings : existingDiagnosticSettings
output id string = newOrExistingHostPool == 'new' ? newDiagnosticSettings.id : existingDiagnosticSettings.id
output name string = newOrExistingHostPool == 'new' ? newDiagnosticSettings.name : existingDiagnosticSettings.name
