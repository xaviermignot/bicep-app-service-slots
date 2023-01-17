targetScope = 'subscription'

param location string
param project string

@allowed([ 'blue', 'green' ])
param activeApp string = 'blue'

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
    activeApp: activeApp
  }
}

output rgName string = rg.name
output appServiceName string = resources.outputs.appServiceName
