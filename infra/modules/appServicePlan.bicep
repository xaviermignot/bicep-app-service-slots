param location string
param project string

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-${project}'
  location: location

  kind: 'app,linux'

  properties: {
    reserved: true
  }

  sku: {
    name: 'P0V3'
  }
}

output planId string = plan.id
