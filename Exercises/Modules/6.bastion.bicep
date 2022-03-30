
// Parameters

@description('Virtual network for the BastionHost association')
param vnetName string = '${resourceGroup().name}-vnet'

@description('Azure region for the BastionHost')
param location string = resourceGroup().location

// Resource: Reference to existing VNET
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
}

// Resource: Reference to existing AzureBastionSubnet 
resource bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  parent: vnet
  name: 'AzureBastionSubnet'
}

// public IP ref
resource pubIp 'Microsoft.Network/publicIPAddresses@2021-05-01' existing = {
  name: '${resourceGroup().name}-bastion-pubip'
}

// Resource: Azure Bastion Host
resource bastion 'Microsoft.Network/bastionHosts@2021-05-01' = {
  name: '${resourceGroup().name}bastion'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    ipConfigurations:[
      {
        name: 'ipconf'
        properties: {
          subnet: {
            id: bastionSubnet.id
          }
          publicIPAddress: {
            id: pubIp.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// Outputs
output bastionUrl string = bastion.properties.dnsName
