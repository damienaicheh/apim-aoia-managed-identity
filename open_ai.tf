resource "azurerm_cognitive_account" "open_ai" {
  name                  = format("oai-%s", local.resource_suffix_kebabcase)
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  kind                  = "OpenAI"
  sku_name              = "S0"
  tags                  = local.tags
  custom_subdomain_name = format("oai-%s", local.resource_suffix_kebabcase)

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_cognitive_deployment" "chat_model" {
  name                 = local.chat_model_name
  cognitive_account_id = azurerm_cognitive_account.open_ai.id
  model {
    format  = "OpenAI"
    name    = local.chat_model_name
    version = "0301"
  }

  scale {
    type     = "Standard"
    capacity = 5
  }
}