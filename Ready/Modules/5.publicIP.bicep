// Parameters


@description('Azure region where the PIP should be created')
param location string = resourceGroup().location

@description('Sku')
@allowed([
  'Basic'
  'Standard'
])
param sku string = 'Basic'

// Variables
var requireStaticAllocation = sku == 'Standard'    // needed for standard sku

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: '${resourceGroup().name}-bastion-pubip'
  sku: {
    name: 'Standard'
  }
  location: location
  properties: {
    publicIPAllocationMethod: requireStaticAllocation ? 'Static' : 'Dynamic'
  }
}

// Outputs
output resource object = publicIP
output name string = publicIP.name
output id string = publicIP.id


