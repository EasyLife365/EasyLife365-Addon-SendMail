param stage string
param applicationName string
param resourceNamesPrefix string
param location string = resourceGroup().location
param mailFromAddress string
param mailToAddresses string

module logAnalyticsModule 'loganalyticsWorkspace.bicep' = {
  name: 'logAnalyticsModule'
  params: {
    name: '${resourceNamesPrefix}-${applicationName}-${stage}-la'
    location: location
  }
}

var functionName = '${resourceNamesPrefix}-${applicationName}-${stage}-fa'
module functionAppModule 'functionApp.bicep' = {
  name: 'functionAppModule'
  dependsOn: [
    logAnalyticsModule
  ]
  params: {
    functionName: functionName
    stage: stage
    resourceNamesPrefix: resourceNamesPrefix
    applicationName: applicationName
    location: location
    workspaceId: logAnalyticsModule.outputs.logAnalyticsWorkspaceID
    mailFromAddress: mailFromAddress
    mailToAddresses: mailToAddresses
  }
}

output functionName string = functionName
output functionPrincipalId string = functionAppModule.outputs.functionPrincipalId
