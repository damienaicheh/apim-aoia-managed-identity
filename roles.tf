resource "azurerm_role_assignment" "this" {
  scope                = azurerm_cognitive_account.open_ai.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_api_management.this.identity[0].principal_id
}