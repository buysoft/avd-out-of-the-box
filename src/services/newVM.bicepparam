using './newVM.bicep'

param artifactsLocation = 'https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.02698.323.zip'
param hostpoolName = 'hostpool-dev-test-001'
param hostpoolToken = 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjFGNjUyNTM1QjBDMzFGMzRCQkNDNUQ0Njc1MEM2N0UzQjIzMzIyNkEiLCJ0eXAiOiJKV1QifQ.eyJSZWdpc3RyYXRpb25JZCI6IjgyNzZmMDhjLTFjZjItNGZkYi1iYzY0LTA2MDM0NzZiNTcxOCIsIkJyb2tlclVyaSI6Imh0dHBzOi8vcmRicm9rZXItZy1ldS1yMC53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1VyaSI6Imh0dHBzOi8vcmRkaWFnbm9zdGljcy1nLWV1LXIwLnd2ZC5taWNyb3NvZnQuY29tLyIsIkVuZHBvaW50UG9vbElkIjoiMjZlNDVlOWUtZGU5My00MzVmLWI4ZTMtOWYwZjlkYmVmZWU2IiwiR2xvYmFsQnJva2VyVXJpIjoiaHR0cHM6Ly9yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJHZW9ncmFwaHkiOiJFVSIsIkdsb2JhbEJyb2tlclJlc291cmNlSWRVcmkiOiJodHRwczovLzI2ZTQ1ZTllLWRlOTMtNDM1Zi1iOGUzLTlmMGY5ZGJlZmVlNi5yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJCcm9rZXJSZXNvdXJjZUlkVXJpIjoiaHR0cHM6Ly8yNmU0NWU5ZS1kZTkzLTQzNWYtYjhlMy05ZjBmOWRiZWZlZTYucmRicm9rZXItZy1ldS1yMC53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1Jlc291cmNlSWRVcmkiOiJodHRwczovLzI2ZTQ1ZTllLWRlOTMtNDM1Zi1iOGUzLTlmMGY5ZGJlZmVlNi5yZGRpYWdub3N0aWNzLWctZXUtcjAud3ZkLm1pY3Jvc29mdC5jb20vIiwiQUFEVGVuYW50SWQiOiJkOWM3MmNkOS1lM2YyLTQyNjctYTdiNS02ODJmYTA2NGU4YjMiLCJuYmYiOjE3MTY0NDgzNzEsImV4cCI6MTcxNjUzNDcyMywiaXNzIjoiUkRJbmZyYVRva2VuTWFuYWdlciIsImF1ZCI6IlJEbWkifQ.PEyKZzr7tfkgY5DRyEnSq5nOa_ooWklAIbXhy4MUMnKMcipKfqU-yNwS5XNNCLp89FsUcSN5nFWTIa-C6KiQJzqxtv8h_CEJLw-T7uHDbgHy7klEOTuvX8qv_by9360FVM2y27ZrV5IsS2LfKuZe8qAxN-zTmrb8XPnYrNFxw3DqZAs8NVlazlb9WJIvNZ5PmyQVA8GcRIWSoFmgbkMn0xTxDz7_tdsmfBO5wXNaFBX7qVfW4G2jn3XndtxkSYCt1SSGOk7y5fyyZjMW4gslmA9Lh0d5f2sjC91E_1FwFrBiWsNavkUh6w0jfs02j7Fd7FpK9MjVQq8bm9-9c_7LYQ'
param vmLocalUsername = 'localadmin'
param vmLocalPassword = '4b44cd99-2eec-4dca-a911-7d7c292dd2e3'
param vmResourceGroup = 'rg-avd-hostpool-dev-001'
param vmLocation = 'westeurope'
param vmSize = 'Standard_B2as_v2'
param vmInitialNumber = 3
param vmNumberOfInstances = 1
param vmNamePrefix = 'dtxdevtst'
// param vmCustomImageSourceId = '/subscriptions/4244f0c4-0776-47a7-a422-885726a8c7b6/resourceGroups/rg-sharedimagegallery-dev-001/providers/Microsoft.Compute/galleries/galautomationdev001/images/id-galautomationdev001/versions/1.0.4'
param galleryName = 'galautomationdev001'
param galleryImageName = 'id-galautomationdev001'
param galleryImageVersion = 'latest'
param existingVnetName = 'testvnet'
param existingSubnetName = 'default'
param virtualNetworkResourceGroupName = 'rg-temp-createimageavdwin11'
param bootDiagnostics = {
  enabled: false
}
param secureBoot = true
param vTPM = true
param managedDiskSecurityEncryptionType = 'VMGuestStateOnly'
param integrityMonitoring = false
