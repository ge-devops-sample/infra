variable "client_id" {}
variable "client_secret" {}

variable "resource_prefix" {
    default = "ge-ren-ga-devops-demo"
}

variable "agent_count" {
    default = 2
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8s"
}

variable cluster_name {
    default = "k8s"
}

variable acr_name {
    default = "gedevopsacrdemo"
}

variable resource_group_name {
    default = "micro-services-rg"
}

variable location {
    default = "Central US"
}

variable log_analytics_workspace_name {
    default = "LogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "eastus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}