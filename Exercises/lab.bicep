// Scope
targetScope = 'resourceGroup'

// Params

@description('Name of the virtual machine to be provisioned')
param vmName string = 'testrg-linuxvm-1'

@description('Admin user name for the virtual machine')
param adminUserName string = 'mcidev'

@description('Azure region where the resources should be provisioned')
param location string = resourceGroup().location

// Existing main subnet
resource mainSubnet 'Microsoft.Network/virtualnetworks/subnets@2015-06-15' existing = {
  name: '${resourceGroup().name}-vnet/mainSubnet'
}

// TIP: Complete this resource to reference the existing Network Security Group by name, we created in previous exercise
// TIP: Keep the symbolic name as nsg (no change)
resource nsg  

// New Network Interface
module nic  = {     //TIP: use the NIC module type after the symbolic name nic and before =
  name: 'nic${uniqueString(resourceGroup().name)}'
  params: {
    location: location
    // Implicit dependency based on output reference to the resource property
    nsgId:                     //TIP: Set the existing NSG id
    subnetId:                  //TIP: Set the existing main subnet id           
  }
}

