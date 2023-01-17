targetScope = 'subscription'

param project string

param location string

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${project}'
  location: location
}

module resources 'resources.bicep' = {
  name: 'deploy-${project}-resources'
  scope: rg

  params: {
    location: location
    project: project
  }
}
