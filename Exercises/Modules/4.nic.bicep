// Parameters
@description('Subnet for the NIC to be associated with')
param subnetId string 

@description('Resource id of the Network Security Group for the NIC')
param nsgId string 

@description('Should the NIC PrivateIP be static')
param requireStaticPrivateIP bool = false

@description('Azure region where the NIC should be created')
param location string = resourceGroup().location

// Resource: Network Interface 
resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${resourceGroup().name}-nic'
  location: location
  properties: {
    networkSecurityGroup: {
      id: nsgId
    }
    ipConfigurations: [
      {
        name: '${resourceGroup().name}-nic-ip'
        properties: {
          privateIPAllocationMethod: requireStaticPrivateIP ? 'Static' : 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

// Outputs
output resource object = nic
output name string = nic.name
output id string = nic.id
