using './imageTemplate.bicep'

param imageTemplateName = 'avd11ImageTemplate'
param userAssignedIdentityId = '/subscriptions/4244f0c4-0776-47a7-a422-885726a8c7b6/resourcegroups/rg-sharedimagegallery-dev-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-galautomationdev001'
param stagingResourceGroupName = 'rg-temp-createimageavdwin11'
