// Scope
targetScope = 'resourceGroup'

// Params

@description('Name of the virtual machine to be provisioned')
param vmName string

@description('Admin user name for the virtual machine')
param adminUserName string = 'mcidev'

@description('Admin user password')
@secure()
param adminPassword string

@description('Azure region where the resources should be provisioned')
param location string = resourceGroup().location

// Existing VNET reference
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name:'${resourceGroup().name}-vnet' 
}

// Existing main subnet
resource mainSubnet 'Microsoft.Network/virtualnetworks/subnets@2015-06-15' existing = {
  name: '${resourceGroup().name}-vnet/mainSubnet'
}

// Existing Network Security Group
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' existing = {
  name: '${resourceGroup().name}-nsg'
  location: location
}

// New Network Interface
module nic './Modules/3.nic.bicep' = {
  name: 'nic${uniqueString(resourceGroup().name)}'
  params: {
    location: location
    nsgId: nsg.id           // Implicit dependency based on output reference to the resource property
    subnetId: mainSubnet.id
  }
}

// Linux VM
var vmDepName = 'vm${uniqueString(resourceGroup().name)}'
module linuxvm './Modules/4.linuxvm.bicep' = {
  name: vmDepName
  params: {
    location:location
    nicId: nic.outputs.id
    vmName: vmName
    adminUserName: adminUserName 
    adminPassword: adminPassword
  }
}

// Bastion public IP
var bastionIpDepName = 'bastionIp${uniqueString(resourceGroup().name)}'
module bastionPubIp './Modules/5.publicIP.bicep' = {
  name: bastionIpDepName
  params:{ 
    location: location
    sku: 'Standard'
  }
}

// Bastion Host
var bastionDepName = 'bastion${uniqueString(resourceGroup().name)}'
module bastion 'Modules/6.bastion.bicep' = {
  name: bastionDepName
  dependsOn: [
    linuxvm                                   // Explicit depencency on the vm resource creation 
  ]   
  params: {
    location: location
    publicIpId: bastionPubIp.outputs.id   // Implict dependency on public IP creation
    vnetName: vnet.name                   
  }
}

output bastionurl string = bastion.outputs.bastionUrl


