resource "azurerm_api_management" "this" {
  name                 = format("apim-%s", local.resource_suffix_kebabcase)
  location             = azurerm_resource_group.this.location
  resource_group_name  = azurerm_resource_group.this.name
  publisher_name       = "Me"
  publisher_email      = "admin@me.io"
  sku_name             = "Developer_1"
  tags                 = local.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_api_management_api" "open_ai" {
  name                = "api-azure-open-ai"
  resource_group_name = azurerm_resource_group.this.name
  api_management_name = azurerm_api_management.this.name
  revision            = "1"
  display_name        = "Azure Open API"
  path                = "openai"
  protocols           = ["https"]

  import {
    content_format = "openapi+json"
    content_value  =  data.template_file.open_ai_spec.rendered
  }
}

resource "azurerm_api_management_backend" "open_ai" {
  name                = "azure-open-ai-backend"
  resource_group_name = azurerm_resource_group.this.name
  api_management_name = azurerm_api_management.this.name
  protocol            = "http"
  url                 = format("%sopenai", azurerm_cognitive_account.open_ai.endpoint)
}

resource "azurerm_api_management_api_policy" "global_open_ai_policy" {
  api_name            = azurerm_api_management_api.open_ai.name
  resource_group_name = azurerm_resource_group.this.name
  api_management_name = azurerm_api_management.this.name

  xml_content = data.template_file.global_open_ai_policy.rendered
}