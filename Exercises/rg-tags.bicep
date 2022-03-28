// Scope
targetScope = 'subscription'

// Parameters
@description('Resource group name')
param name string

@description('Azure region name')
param location string

@description('Tags')
param tags object =   {
    'testtag': 'testvalue'
  }


// Resources
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: name
  tags: tags
}



