param location string
param project string

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-${project}'
  location: location

  kind: 'linux'

  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
  }
}

output planId string = plan.id
