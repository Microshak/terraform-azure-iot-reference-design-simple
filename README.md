# Azure IoT Reference Design
Guide to Terraforming IoT Reference Design in Azure

### Getting started

1. Go to shell.azure.com
2. git clone this repo
3. navigate to the cloned root
4. use the terraform commands to build or tear down Azure Resources

### Terraform commnds
terraform init - inits the workspace

terraform plan - checks for errors

terraform apply - deploys

terraform destroy - tears down


### Cloud Shell
Instead of installing the Azure CLI, setting up a Service Principal and the rest of the Terraform Variables you can use the Azure Portal Cloud Shell.

We have made the Terraform experience as simple as possible, as all of the environment details are setup based on your default account through the Azure CLI.

![alt text](https://github.com/justindavies/TerraformOnAzure/raw/master/images/using-cloud-shell-it-has-my-terraform-variables.jpg "Win!")


