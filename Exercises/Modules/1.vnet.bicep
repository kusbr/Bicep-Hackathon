
@description('Name of the azure network.')
param vnetName string = '${resourceGroup().name}-vnet'

@description('Specifies the addressPrefix for the vnet.')
param vnetAddressPrefixes string = '192.168.0.0/16'

@description('Subnets configuration in the network')
param subnets array = [
  {
    name: 'mainSubnet'
    subnetPrefix: '192.168.0.0/23'
  }
  {
    name: 'AzureBastionSubnet'
    subnetPrefix: '192.168.2.0/26'
  }
]

@description('Azure region where the VNET should be created')
param location string = resourceGroup().location

// Resource: Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  //Tip: Add the VNET resource related  properties like subnets
  
  name: vnetName
  location: location

  properties: {
    
    //Tip: Add addressSpace

    //Tip: Add subnets (requires 'for' loop)
  }
}

// Outputs
output resource object = vnet
output name string = vnet.name
output id string = vnet.id
output subnetid string =       //Tip: Set the value to the resource id of the first subnet
