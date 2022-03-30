// Scope
targetScope = 'resourceGroup'

// Parameters

@description('Name of the virtual machine')
param vmName string

@description('VM local admin user name')
param adminUserName string

@secure()
@description('Admin Password ')
param adminPassword string

// Get-AzVMImageSku -Location 'centralindia'  -PublisherName 'Canonical'  -Offer 'UbuntuServer' | Select Skus
@allowed([      
  '19.04'
  '19_04-gen2'
  '18_04-lts-gen2'
  '18.04-LTS'
  '16.04-LTS'
])      
param ubuntuOSVersion string = '19.04'

@description('VM Sku')
param vmSize string = 'Standard_D4s_v4'

@description('Resource Id of the NIC')
param nicId string

@description('Azure region where the VNET should be created')
param location string = resourceGroup().location

// Resource: Basic Linux VM using Canonical UbuntuServer image loaded on Standard LRS OS Disk and single NIC
resource virtualMachine 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: vmName
  location: location

  properties:{

    // HW Sku
    hardwareProfile:{
      vmSize: vmSize
    }

    // OS 
    osProfile:{
      computerName: vmName
      adminUsername: adminUserName
      adminPassword: adminPassword
      linuxConfiguration:{ 
                            // TIP: Add disablePasswordAuthentication and set it to false
      }
    }

    // Storage
    storageProfile:{
      
      // OS Disk
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }

      // OS Image Ref
      imageReference:{
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: ubuntuOSVersion
        version: 'latest'
      }
    }

    // Network
    networkProfile:{
      networkInterfaces: [
        {
          id: nicId
        }
      ]
    }
  }
}


