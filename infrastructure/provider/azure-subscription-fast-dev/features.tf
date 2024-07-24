// Make nodes communicate with control plane over private vnet.
// Requires one time run of the following:
//   az extension add --name aks-preview
//   az extension update --name aks-preview
//   az feature register --namespace "Microsoft.ContainerService" --name "EnableAPIServerVnetIntegrationPreview"
//   -- wait ~10 minutes for feature to be enabled, check for "Registered" status with:
//   az feature show --namespace "Microsoft.ContainerService" --name "EnableAPIServerVnetIntegrationPreview"
//   -- apply with:
//   az provider register --namespace Microsoft.ContainerService
// ref: https://learn.microsoft.com/en-us/azure/aks/api-server-vnet-integration#prerequisites

// Make it possible for pods to assume azure identities.
// Requires one time run of the following:
//   az feature register --namespace "Microsoft.ContainerService" --name "EnableWorkloadIdentityPreview"
//   -- wait ~10 minutes for feature to be enabled, check for "Registered" status with:
//   az feature show --namespace "Microsoft.ContainerService" --name "EnableWorkloadIdentityPreview"
//   -- apply with
//   az provider register --namespace Microsoft.ContainerService
