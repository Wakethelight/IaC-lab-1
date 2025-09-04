resource "azurerm_policy_definition" "restrict_aci_region" {
  name         = "restrict-aci-region"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Restrict ACI Regions"
  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.ContainerInstance/containerGroups"
        },
        {
          "not": {
            "field": "location",
            "in": ["East US", "East US 2"]
          }
        }
      ]
    },
    "then": {
      "effect": "Deny"
    }
  }
  POLICY_RULE
}