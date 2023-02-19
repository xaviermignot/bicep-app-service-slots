# Azure App Service with Bicep, deployment slots and app settings

This repository contains a demo on how to use Azure Services deployment slots with Bicep (yes, with app settings too !). It is an adaptation of a demo I had previously made using [Terraform](https://github.com/xaviermignot/terraform-app-service-slots), and it's covered by a series of two posts on my blog [here](https://blog.xmi.fr/posts/app-service-bicep-github-actions/) and [here](https://blog.xmi.fr/posts/bicep-app-service-slots/).  
The demo consists in:
- a few Bicep files to provision an App Service and a deployment slot
- a simple ASP.NET web app
- GitHub Action workflows to:
  - provision the Azure resources
  - deploy the web app: the _blue_ version on the _production_ slot, and the _green_ version on the _staging_ slot
  - swap the _staging_ slot with the _production_ one (as many time of you want)
  - destroy the Azure resources once you have finished to save costs

## Getting started

To run this demo by yourself there is nothing to install on you machine as everything is running in the cloud. You need to configure a few things in GitHub and in you Azure subscription.  

### Create a service principal in Azure
To grant access to your Azure subscription to the GitHub Action runners, you need to create a service principal with the _contributor_ role to your subscription.  
Everything is well explained [here](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux#create-an-azure-active-directory-application-and-service-principal), follow the instructions and save your subscriptionId for later.

### Fork the repository and set a few secrets
To run the GitHub Actions workflows you need to fork this repository. I haven't tested the fork myself as I don't have a secondary account, so I hope this works.  

In your fork you need to set a few secrets. You should already have the `AZURE_CREDENTIALS` secret set from the previous step.  
Add these secrets required to deploy the Bicep templates:
- `AZURE_SUBCRIPTION` with your subscription id
- `AZURE_REGION` with the Azure region you want to use

Then, as some of the workflows are creating secrets in GitHub, you'll need to create a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for that with the following permissions:
- Access to your fork's repo
- Read and write access to secrets (this will also select the read access to metadata)

Once the PAT generated, save its value in the `GH_PAT` secret, and you're all set !

## Run the demo

Once everything has been set-up you can run the `01 - Initial deployment` workflow from the Actions tab in GitHub. This will create the resources in Azure, deploy a _blue_ version of the code in the production slot, and a _green_ version of the code in staging.  
Go to the Azure portal to see the resources in the `rg-aps-slots-demo` resource group. You can browse both versions from there.

To make a swap, run `02 - Swap App Service slots using Azure CLI` workflow.  
Once the swap has been done, refresh the app in your browser, you should see the _green_ version in production and the _blue_ one in staging.

Eventually you can perform another swap if you want to simulate a rollback.  

Lastly, do not forget to run the `03 - Destroy Azure resources with Azure CLI` once you have finished to save costs as the App Service runs in a Standard plan, which is not free of charge.
