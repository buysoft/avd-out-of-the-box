{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "hciArtifactsLocation": {
            "value": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/HCIScripts_1.0.02698.323/HciCustomScript.ps1"
        },
        "customLocationId": {
            "value": ""
        },
        "virtualProcessorCount": {
            "value": null
        },
        "memoryMB": {
            "value": 0
        },
        "maximumMemoryMB": {
            "value": 0
        },
        "minimumMemoryMB": {
            "value": 0
        },
        "dynamicMemoryConfig": {
            "value": false
        },
        "vmInfrastructureType": {
            "value": "Cloud"
        },
        "artifactsLocation": {
            "value": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.02698.323.zip"
        },
        "nestedTemplatesLocation": {
            "value": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/armtemplates/Hostpool_1.0.02698.323/nestedTemplates/"
        },
        "hostpoolName": {
            "value": "hostpool-dev-test-001"
        },
        "hostpoolProperties": {
            "value": {
                "agentUpdate": null,
                "friendlyName": null,
                "description": "Created through the Azure Virtual Desktop extension",
                "hostPoolType": "Pooled",
                "personalDesktopAssignmentType": null,
                "applicationGroupReferences": [
                    "/subscriptions/4244f0c4-0776-47a7-a422-885726a8c7b6/resourcegroups/rg-avd-hostpool-dev-001/providers/Microsoft.DesktopVirtualization/applicationgroups/hostpool-dev-test-001-DAG"
                ],
                "customRdpProperty": "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;",
                "maxSessionLimit": 99999,
                "loadBalancerType": "BreadthFirst",
                "validationEnvironment": false,
                "ring": null,
                "registrationInfo": null,
                "vmTemplate": "{\"domain\":\"\",\"galleryImageOffer\":null,\"galleryImagePublisher\":null,\"galleryImageSKU\":null,\"imageType\":\"CustomImage\",\"customImageId\":\"/subscriptions/4244f0c4-0776-47a7-a422-885726a8c7b6/resourceGroups/rg-sharedimagegallery-dev-001/providers/Microsoft.Compute/galleries/galautomationdev001/images/id-galautomationdev001/versions/1.0.4\",\"namePrefix\":\"hostdtxdev\",\"osDiskType\":\"StandardSSD_LRS\",\"vmSize\":{\"id\":\"Standard_D2as_v4\",\"cores\":2,\"ram\":8,\"rdmaEnabled\":false,\"supportsMemoryPreservingMaintenance\":true},\"galleryItemId\":null,\"hibernate\":false,\"diskSizeGB\":0,\"securityType\":\"TrustedLaunch\",\"secureBoot\":true,\"vTPM\":true,\"vmInfrastructureType\":\"Cloud\",\"virtualProcessorCount\":null,\"memoryGB\":null,\"maximumMemoryGB\":null,\"minimumMemoryGB\":null,\"dynamicMemoryConfig\":false}",
                "preferredAppGroupType": "Desktop",
                "migrationRequest": null,
                "cloudPcResource": false,
                "startVMOnConnect": false,
                "ssoadfsAuthority": null,
                "ssoClientId": null,
                "ssoClientSecretKeyVaultPath": null,
                "ssoSecretType": null,
                "objectId": "26e45e9e-de93-435f-b8e3-9f0f9dbefee6"
            }
        },
        "hostpoolResourceGroup": {
            "value": "rg-avd-hostpool-dev-001"
        },
        "hostpoolLocation": {
            "value": "westeurope"
        },
        "hostpoolToken": {
            "value": null
        },
        "vmInitialNumber": {
            "value": 0
        },
        "vmResourceGroup": {
            "value": "rg-temp-createimageavdwin11"
        },
        "vmLocation": {
            "value": "westeurope"
        },
        "vmExtendedLocation": {
            "value": null
        },
        "vmNamePrefix": {
            "value": "hostdtxdev"
        },
        "vmNumberOfInstances": {
            "value": 1
        },
        "vmSize": {
            "value": "Standard_D2as_v4"
        },
        "vmDiskType": {
            "value": "StandardSSD_LRS"
        },
        "vmDiskSizeGB": {
            "value": 0
        },
        "vmHibernate": {
            "value": false
        },
        "availabilityOption": {
            "value": "AvailabilityZone"
        },
        "availabilitySetName": {
            "value": ""
        },
        "createAvailabilitySet": {
            "value": false
        },
        "availabilitySetUpdateDomainCount": {
            "value": 5
        },
        "availabilitySetFaultDomainCount": {
            "value": 2
        },
        "availabilityZones": {
            "value": [
                1
            ]
        },
        "securityType": {
            "value": "TrustedLaunch"
        },
        "secureBoot": {
            "value": true
        },
        "vTPM": {
            "value": true
        },
        "managedDiskSecurityEncryptionType": {
            "value": "VMGuestStateOnly"
        },
        "integrityMonitoring": {
            "value": true
        },
        "vmImageType": {
            "value": "CustomImage"
        },
        "bootDiagnostics": {
            "value": {
                "enabled": true
            }
        },
        "customConfigurationScriptUrl": {
            "value": ""
        },
        "virtualNetworkResourceGroupName": {
            "value": "rg-temp-createimageavdwin11"
        },
        "existingVnetName": {
            "value": "testvnet"
        },
        "existingSubnetName": {
            "value": "default"
        },
        "createNetworkSecurityGroup": {
            "value": false
        },
        "aadJoin": {
            "value": true
        },
        "intune": {
            "value": false
        },
        "domain": {
            "value": ""
        },
        "ouPath": {
            "value": ""
        },
        "vmAdministratorAccountUsername": {
            "value": "localadmin"
        },
        "vmAdministratorAccountPassword": {
            "value": null
        },
        "networkInterfaceTags": {
            "value": {
                "cm-resource-parent": "/subscriptions/4244f0c4-0776-47a7-a422-885726a8c7b6/resourcegroups/rg-avd-hostpool-dev-001/providers/Microsoft.DesktopVirtualization/hostpools/hostpool-dev-test-001"
            }
        },
        "networkSecurityGroupTags": {
            "value": {
                "cm-resource-parent": "/subscriptions/4244f0c4-0776-47a7-a422-885726a8c7b6/resourcegroups/rg-avd-hostpool-dev-001/providers/Microsoft.DesktopVirtualization/hostpools/hostpool-dev-test-001"
            }
        },
        "availabilitySetTags": {
            "value": {
                "cm-resource-parent": "/subscriptions/4244f0c4-0776-47a7-a422-885726a8c7b6/resourceGroups/rg-avd-hostpool-dev-001/providers/Microsoft.DesktopVirtualization/hostpools/hostpool-dev-test-001"
            }
        },
        "virtualMachineTags": {
            "value": {
                "cm-resource-parent": "/subscriptions/4244f0c4-0776-47a7-a422-885726a8c7b6/resourceGroups/rg-avd-hostpool-dev-001/providers/Microsoft.DesktopVirtualization/hostpools/hostpool-dev-test-001"
            }
        },
        "deploymentId": {
            "value": "80537cff-2b89-43ed-81cc-16784fe4f1aa"
        },
        "apiVersion": {
            "value": "2022-10-14-preview"
        },
        "vmCustomImageSourceId": {
            "value": "/subscriptions/4244f0c4-0776-47a7-a422-885726a8c7b6/resourceGroups/rg-sharedimagegallery-dev-001/providers/Microsoft.Compute/galleries/galautomationdev001/images/id-galautomationdev001/versions/1.0.4"
        },
        "systemData": {
            "value": {
                "aadJoinPreview": false,
                "sessionHostConfigurationVersion": "",
                "firstPartyExtension": false
            }
        }
    }
}
