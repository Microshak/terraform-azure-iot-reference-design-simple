
# IoTHub
variable "azurerm_iothub" {}

#Resource Group
resource "azurerm_resource_group" "iotreference" {
  name     = "${var.resource_group}"
  location = "${var.location}"
}


resource "azurerm_iothub" "iotreference" {
  name                = "${var.iothub}"
  resource_group_name = "${azurerm_resource_group.iotreference.name}"
  location            = "${azurerm_resource_group.iotreference.location}"
  sku {
    name = "S1"
    tier = "Standard"
    capacity = "1"
  }

  tags {
    "purpose" = "testing"
  }
  depends_on = ["azurerm_resource_group.iotreference"]

}

##COMOS DB
resource "azurerm_cosmosdb_account" "iotreference" {
  name                = "${var.cosmosdb_account_name}"
  location            = "${azurerm_resource_group.iotreference.location}"
  resource_group_name = "${azurerm_resource_group.iotreference.name}"
  offer_type          = "${var.cosmosdb_offer_type}"

  consistency_policy {
    consistency_level = "${var.cosmosdb_consistency_level}"
  }

  failover_policy {
    location = "${azurerm_resource_group.iotreference.location}"
    priority = 0
  }

  # Create Cosmos DB and Collection. It requires az command
  # https://docs.microsoft.com/ja-jp/azure/cosmos-db/scripts/create-database-account-collections-cli?toc=%2fcli%2fazure%2ftoc.json

  provisioner "local-exec" {
    command = "az cosmosdb database create --name ${var.cosmosdb_account_name} --db-name ${var.stream_analytics_cosmosdb_name} --resource-group ${azurerm_resource_group.iotreference.name}"
  }
  provisioner "local-exec" {
    command = "az cosmosdb collection create --collection-name ${var.stream_analytics_cosmosdb_collection_name_pattern} --name ${var.cosmosdb_account_name} --db-name ${var.stream_analytics_cosmosdb_name} --resource-group ${azurerm_resource_group.iotreference.name} --partition-key-path ${var.stream_analytics_cosmosdb_partition_key}"
  }
  tags {
    environment = "${var.environment}"
  }
  depends_on = ["azurerm_resource_group.iotreference"]
}



#STREAM ANALYICS

resource "azurerm_template_deployment" "iotreference" {
  name                = "stream-deployment-01"
  resource_group_name = "${azurerm_resource_group.iotreference.name}"
  template_body       = "${file("${path.cwd}/template/template.json")}"

  parameters {
    // Stream Analytics parameter
    name       = "${var.stream_analytics_name}"
    location   = "${azurerm_resource_group.iotreference.location}"
    apiVersion = "2016-03-01"
    sku        = "${var.stream_analytics_sku}"
    jobType    = "Cloud"

    // streamingUnits = "1"
    eventHubNameSpace              = "${azurerm_iothub.iotreference.name}"
    eventHubSharedAccessPolicyName = "RootManageSharedAccessKey"                                // need investigate
    //eventHubSharedAccessKey        = "${azurerm_iothub.iotreference.shared_access_policy.primary_key}"  //BUG https://github.com/terraform-providers/terraform-provider-azurerm/issues/1414
    eventHubName                   = "${azurerm_iothub.iotreference.name}"
    cosmosDBAccountName            = "${azurerm_cosmosdb_account.iotreference.name}"
    cosmosDBAccountKey             = "${azurerm_cosmosdb_account.iotreference.primary_master_key}"
    cosmosDBDatabaseName           = "${var.stream_analytics_cosmosdb_name}"
    cosmosDBCollectionNamePattern  = "${var.stream_analytics_cosmosdb_collection_name_pattern}"
    cosmosDBPartitionKey           = "${var.stream_analytics_cosmosdb_partition_key}"
  }

  deployment_mode = "Incremental"
  depends_on      = ["azurerm_resource_group.iotreference", "azurerm_cosmosdb_account.iotreference", "azurerm_iothub.iotreference"]
}