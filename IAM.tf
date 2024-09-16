#To create a user.
resource "azuread_user" "IAM_user" {
  user_principal_name = "vishal@Sinhgadinstituteoftechno425.onmicrosoft.com"
  display_name         = "Vishal_nimbalkar"
  password             = "Vishwasnagar@123"  
  force_password_change = false
  depends_on = [azurerm_resource_group.rg1]
}

#To create a role definiation.
resource "azurerm_role_definition" "Reader_RG" {
  name = "Reader_RG"
  scope = "${azurerm_resource_group.rg1.id}" 
  description = "This is the custome role created for the resources in the rg1 resource group"
  depends_on = [azuread_user.IAM_user]

  permissions {
    actions     = ["*"]
    not_actions = [
        "Microsoft.Compute/*/delete" ,
        "Microsoft.Compute/*/write"
    ]
  }

  assignable_scopes = [
    "${azurerm_resource_group.rg1.id}" 
  ]
}

#To create role assignment.
resource "azurerm_role_assignment" "IAM_assignment" {
  principal_id = "${azuread_user.IAM_user.object_id}"
  role_definition_name = "${azurerm_role_definition.Reader_RG.name}"
  scope = "${azurerm_resource_group.rg1.id}"
  depends_on = [azurerm_role_definition.Reader_RG]
}