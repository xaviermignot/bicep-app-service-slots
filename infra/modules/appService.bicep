param location string
param project string

param appName string
param planId string
@allowed([ 'blue', 'green' ])
param activeApp string = 'blue'

param blueAppSettings array = []
param greenAppSettings array = []

var linuxFxVersion = 'DOTNETCORE|6.0'
resource app 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-${project}-${appName}'
  location: location

  properties: {
    serverFarmId: planId
    reserved: true

    siteConfig: {
      linuxFxVersion: linuxFxVersion
      appSettings: activeApp == 'blue' ? blueAppSettings : greenAppSettings
    }
  }
}

var slotAppSettings = activeApp == 'blue' ? greenAppSettings : blueAppSettings
resource staging 'Microsoft.Web/sites/slots@2022-03-01' = {
  name: 'staging'
  location: location
  parent: app

  properties: {
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      appSettings: concat(slotAppSettings, [ {
            name: 'IsStaging'
            value: true
          } ])
    }
  }
}

resource stickySettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'slotConfigNames'
  parent: app

  properties: {
    appSettingNames: [ 'IsStaging' ]
  }
}

output appServiceName string = app.name
