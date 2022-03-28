
@description('Destination IP prefix for the NSG rule')
param destinationPrefix string = '192.168.0.0/16'   // Example VNET address space

@description('Azure region where the NSG should be created')
param location string = resourceGroup().location

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: '${resourceGroup().name}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'nsgRule'
        properties: {
          description: 'SSH'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: destinationPrefix
          destinationPortRange: '22'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}

output resource object = nsg
output name string = nsg.name
output id string = nsg.id
