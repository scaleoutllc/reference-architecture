# data "azurerm_billing_mca_account_scope" "main" {
#   billing_account_name = "1891bf6e-062a-531b-104d-7e25cde53150:7c8bb8c2-d5a5-4cb7-af98-abb0d26db724_2019-05-31"
#   billing_profile_name = "B6E6-RLS3-BG7-PGB"
#   invoice_section_name = "KZPY-5EMN-PJA-PGB"
# }

# resource "azurerm_subscription" "main" {
#   subscription_name = "fast-dev-azure"
#   billing_scope_id  = data.azurerm_billing_mca_account_scope.main.id
# }
