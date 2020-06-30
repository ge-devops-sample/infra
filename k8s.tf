resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name
    location = var.location
}

resource "random_id" "suffix" {
    byte_length = 2
}

resource "azurerm_log_analytics_workspace" "workspace" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = "${var.resource_prefix}-${var.log_analytics_workspace_name}"
    location            = var.log_analytics_workspace_location
    resource_group_name = azurerm_resource_group.rg.name
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "solution" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.workspace.location
    resource_group_name   = azurerm_resource_group.rg.name
    workspace_resource_id = azurerm_log_analytics_workspace.workspace.id
    workspace_name        = azurerm_log_analytics_workspace.workspace.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_container_registry" "acr" {
  name                     = "${var.acr_name}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  tags = {
        Environment = "Development"
    }
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "${var.resource_prefix}-${var.cluster_name}"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    dns_prefix          = var.dns_prefix

    #linux_profile {
    #    admin_username = "ubuntu"

    #    ssh_key {
    #        key_data = file(var.ssh_public_key)
    #    }
    #}

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_DS2_v2"
    }

    service_principal {
        client_id     = var.client_id
        client_secret = var.client_secret
    }

    addon_profile {
        oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
        }
    }

    tags = {
        Environment = "Development"
    }
}

/*resource "azurerm_role_assignment" "example" {
    scope                = azurerm_container_registry.acr.id
    role_definition_name = "acrpull"
    principal_id         = azurerm_kubernetes_cluster.k8s.service_principal.0.client_id
}*/
