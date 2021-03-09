@description('Provide location where to deploy resources. Normally, we use WestEurope')
param location string = resourceGroup().location

@description('Name has to be global unique and contain lowercase letters only. Template concatenates a unique suffix to ensure unique name')
param storageAccountName string

@description('LRS- three copies within a single physical location. ZRS- Data is copied synchronously across three Azure availability zones in the primary region. GRS - Cross-regional redundancy to protect against regional outages')
param storageAccountSkuName string = 'Standard_LRS'

@description('Select "ture" to create a hierarchical namespace also known as a Data Lake Gen2')
param isHnsEnabled bool = false

@description('Hot - Optimized for storing data that is accessed frequently.Cool - Optimized for storing data that is infrequently accessed and stored for at least 30 days. Archive - Optimized for storing data that is rarely accessed and stored for at least 180 days with flexible latency requirements, on the order of hours.')
param storageAccessTier string = 'Hot'

@description('Resources of some trusted services can access your storage account in the same subscription')
param storageNetworkAclsBypass string = 'none'

@description('Setting the default network rule to deny blocks all access to the data unless specific network rules that grant access are also applied')
param storageNetworkAclsDefaultAction string = 'deny'

@description('Provide a minimum TLS version, required minimum value is 1.2')
param storageMinimumTlsVersion string = 'TLS1_2'

@description('that is a requirement to use https only')
param storageHttpsOnly bool = true

@description('StorageV2 is a recommended calue for most scenarios using Azure Storage')
param storageAccountKind string = 'StorageV2'

var stgName = toLower('${storageAccountName}${substring(uniqueString(resourceGroup().id),5)}') 

resource storage 'Microsoft.Storage/storageAccounts@2019-06-01' ={
  name: stgName
  location: location
  kind:storageAccountKind
  sku:{
    name: storageAccountSkuName
  }
  properties:{
    accessTier: storageAccessTier
    minimumTlsVersion: storageMinimumTlsVersion
    isHnsEnabled:isHnsEnabled
    networkAcls: {
      defaultAction:storageNetworkAclsDefaultAction
      bypass: storageNetworkAclsBypass
    }
    supportsHttpsTrafficOnly: storageHttpsOnly
  }
}

output storgeId string = storage.id
output storageName string = storage.name