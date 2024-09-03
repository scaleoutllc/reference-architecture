These workspaces manage the configuration for provider level resources: e.g.
account-wide settings in AWS, projects-wide settings in GCP, tenant and
subscription-wide settings in Azure, tenant and compartment level settings in
OCI, dns zones for the entire organization in cloudflare, etc.

It is implied that the resources in this directory could span multiple projects/teams 
and that is why the resource representation in IaC should not live in any single project/team folder.
