# Azure Bicep Lab

## Objective

***
The objective of this lab is to introduce the basic concepts of how to provision Azure resources using Azure Bicep through simple exercises. Note that the advanced concepts are not covered in this lab. As part of this lab, you will use Azure Bicep to provision a **Linux Virtual Machine** and understand the Azure Bicep concepts such as

- Bicep templates
- Scope and dependencies
- Parameters, variables and Bicep functions

## Prerequisites

In order to complete the exercises in this lab, you need a development environment.

|# |Prerequisite  | Reference|
--- | --- | ---|
|1|Azure CLI|[How to install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)|
|2|Azure Bicep|[Install Bicep Tools](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)|
|3|Visual Studio Code| [Install VSCode](https://code.visualstudio.com/)|
|4|Bicep extension for VSCode| [Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)|
|5| Lab Files cloned locally and folder opened in VisualStudio Code| [Github repo](https://github.com/kusbr/Bicep-Hackathon.git)|

Note:

_You can complete the lab by coding the exercises in this document. There is also a ready solution for the lab located under the 'Ready' folder in the lab files._

## How to complete this lab

Each exercise has the following template that you can follow in order to complete:

1. Bicep file to be used
2. Steps - changes to be done in the bicep file
3. Command - az cli command to submit the bicep
4. Outputs - check the resource[s] provisioned by the command
5. Key Points - Bicep concepts used in the exercise

_In the bicep files for the exercises, you can refer the "TIP:" comment to complete the required steps._

***

## Exercise A: Basic Deployment (Provision a new ResourceGroup)

Bicep File: **rg.bicep**

Steps:

1. Set subscription scope
2. Add location parameter to accept azure region for the resource group
3. Set the resource type to 'Microsoft.Resources/resourceGroups@2021-04-01'
4. Pass the location parameters to the resource

Command:

    az deployment sub create --location 'southindia' --parameters name='testrg' location='centralindia' --template-file .\rg.bicep

_Tip: Pass the --location value different from the location parameter_

Outputs:

Check if the new resource group is created



***
## Exercise B: Incremental resource updation -  Add Tags to Resource group

- Use object parameter and pass to the command
- Incremental update

Command:

    az deployment sub create --location 'southindia' --parameter name='testrg' location='centralindia' tags="{'purpose':'learn', 'event':'MCI-India-AzBicepHackathon-31Mar22'}"  --template-file .\rg-tags.bicep

Output:
- New resource group provisioned

## 3. Basic Parameters - Create Storage Account and set properties using params

- Parameters, Default values and Attributes

Command

    az deployment group create --resource-group testrg --template-file .\3.strgacct.bicep  --parameters accessTier='Hot' kind='StorageV2'
