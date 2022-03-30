// Scope
targetScope =     //TIP: Set value as 'subscription'

// Parameters
@description('Resource group name')
param name string = 'testrg'

//TIP: Add a string parameter named location

// Resource   

resource rg '{TIP: resourceGroup resourceType}' = {
  name:     name
  location:     //TIP: Provide the location parameter for value.
}






