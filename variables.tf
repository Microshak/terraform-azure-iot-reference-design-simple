##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)



variable "environment" {
  description = "The name of your Azure Resource Group."
  default     = "test"
}

variable "resource_group"{
description="the name of the resource group"
default="mikerTest"

}

variable "prefix" {
  description = "This prefix will be included in the name of some resources."
  default     = "test"
}



variable "location" {
  description = "The region where the virtual network is created."
  default     = "West US"
}

variable "iothub"{
  description = "The name of the IoT Hub"
default = "mikerIoTHub"
}

# Stream Analytics

variable "stream_analytics_name"{
  description = "The name of the IoT Hub"
default = "mikerSomeJob"
}

variable "stream_analytics_sku"{
  description = "The name of the IoT Hub"
default = "standard"
}

variable "stream_analytics_cosmosdb_name"{
  description = "The name of the IoT Hub"
default = "microdb"
}

variable "stream_analytics_cosmosdb_collection_name_pattern"{
  description = "The name of the IoT Hub"
default = "collection"
}

variable "stream_analytics_cosmosdb_partition_key"{
  description = "The name of the IoT Hub"
default = "/id"
}



# CosmosDB
variable "cosmosdb_account_name"{
  description = "The name of the IoT Hub"
default = "mikersacosmos"
}


variable "cosmosdb_consistency_level"{
  description = "The name of the IoT Hub"
default = "BoundedStaleness"
}

variable "cosmosdb_offer_type"{
  description = "The name of the IoT Hub"
default = "Standard"
}



