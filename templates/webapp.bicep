param skuName string = 'F1'
param skuCapacity int = 1
param location string = resourceGroup().location
param appName string = uniqueString(resourceGroup().id)

var appServicePlanName = toLower('asp-${appName}')
var webSiteName = appName

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName // app service plan name
  location: location       // Azure Region
  kind: 'app,linux'
  properties:{
    reserved:true
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  tags: {
    displayName: 'HostingPlan'
    ProjectName: appName
  }
}

resource webSiteName_resource 'Microsoft.Web/sites@2022-03-01' = {
  name: webSiteName
  location: location
  kind: 'app,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${webSiteName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${webSiteName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: appServicePlan.id
    reserved: true
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'DOTNETCORE|6.0'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '1597C735DF66078452DC20A33144D85D7911321F6F001C1798E05DF49729681C'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource webSiteName_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  parent: webSiteName_resource
  name: 'ftp'
  location: location
  properties: {
    allow: true
  }
}

resource webSiteName_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  parent: webSiteName_resource
  name: 'scm'
  location: location
  properties: {
    allow: true
  }
}

resource webSiteName_web 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: webSiteName_resource
  name: 'web'
  location: location
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'DOTNETCORE|6.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2022'
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$u2u-gamestore'
    scmType: 'VSTSRM'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    publicNetworkAccess: 'Enabled'
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {
    }
  }
}

// resource webSiteName_0568ed0a_6281_40fd_8a0f_568e856c1957 'Microsoft.Web/sites/deployments@2022-03-01' = {
//   parent: webSiteName_resource
//   name: '0568ed0a-6281-40fd-8a0f-568e856c1957'
//   location: location
//   properties: {
//     status: 4
//     author_email: 'N/A'
//     author: 'N/A'
//     deployer: 'VSTS'
//     message: '{"type":"deployment","commitId":"62740e8bdcbcc52c7a7c67dce9977b3eb258ffc9","buildId":"448","buildNumber":"deploy-webapp","repoProvider":"TfsGit","repoName":"bicep","collectionUrl":"https://dev.azure.com/applephi/","teamProject":"411de67c-290f-4aeb-9684-bec46a3a66c1","buildProjectUrl":"https://dev.azure.com/applephi/411de67c-290f-4aeb-9684-bec46a3a66c1","repositoryUrl":"https://applephi@dev.azure.com/applephi/devops-demos/_git/bicep","branch":"main","teamProjectName":"devops-demos","slotName":"production"}'
//     start_time: '2023-03-12T16:18:25.050334Z'
//     end_time: '2023-03-12T16:18:26.9890556Z'
//     active: true
//   }
// }

resource webSiteName_webSiteName_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  parent: webSiteName_resource
  name: '${webSiteName}.azurewebsites.net'
  location: location
  properties: {
    siteName: 'u2u-gamestore'
    hostNameType: 'Verified'
  }
}
