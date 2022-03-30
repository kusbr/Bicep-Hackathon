// Scope
targetScope = 'subscription'

// Parameters
@description('Resource group name')
param name string = 'testrg'

@description('Azure region name')
param location string

@description('Tags')
param tags object =   {
    // Tip: Add tags as multiple name value pairs in different lines
  }


// Resources
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: name
  // Tip: set the tags 
}



