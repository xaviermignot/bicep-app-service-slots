param location string
param project string

@allowed([ 'blue', 'green' ])
param activeApp string = 'blue'

module appServicePlan 'modules/appServicePlan.bicep' = {
  name: 'deploy-plan'
  
  params: {
    location: location
    project: project
  }
}

module appService 'modules/appService.bicep' = {
  name: 'deploy-app-service'

  params: {
    activeApp: activeApp
    appName: uniqueString(subscription().subscriptionId, location, project)
    location: location
    planId: appServicePlan.outputs.planId
    project: project
    blueAppSettings: [
      {
        name: 'EnvironmentName'
        value: 'This is the blue version'
      }
    ]
    greenAppSettings: [
      {
        name: 'EnvironmentName'
        value: 'This is the green version'
      }      
    ]
  }
}

output appServiceName string = appService.outputs.appServiceName
