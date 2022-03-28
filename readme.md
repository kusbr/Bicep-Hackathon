# Azure Bicep Lab

## Objective

***
The objective of this lab is to introduce the basic concepts of how to provision Azure resources using Azure Bicep through simple exercises. Note that the advanced concepts are not covered in this lab. As part of this lab, you will use Azure Bicep to provision a **Linux Virtual Machine** and understand the Azure Bicep concepts such as

- Bicep templates
- Scope and dependencies
- Parameters, variables and Bicep functions

## Prerequisites

***
In order to complete the exercises in this lab, you need a development environment.

|# |Prerequisite  | Reference|
--- | --- | ---|
|1|Azure CLI|[How to install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)|
|2|Azure Bicep|[Install Bicep Tools](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)|
|3|Visual Studio Code| [Install VSCode](https://code.visualstudio.com/)|
|4|Bicep extension for VSCode| [Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)|
|5| Lab Files Package| Lab Files|

Note:

_You can complete the lab by following the exercises in this document. There is also a ready solution for the lab located the 'Ready' folder of the package provided for this lab._

## 1. Basic Deployment - Create a ResourceGroup

- Note subscription scope
- --location deployment parameter is for the ARM service location
- location='centralindia' is passed to bicep parameter
- Observe idempotent operation (run command twice)

Command:

    az deployment sub create --location 'southindia' --parameters name='testrg' location='centralindia' --template-file .\rg.bicep
***
## 2. Incremental Update -  Add Tags to Resource group

- Use object parameter and pass to the command
- Incremental update

Command:

    az deployment sub create --location 'southindia' --parameter name='testrg' location='centralindia' tags="{'purpose':'learn', 'event':'MCI-India-AzBicepHackathon-31Mar22'}"  --template-file .\rg-tags.bicep

## 3. Basic Parameters - Create Storage Account and set properties using params

- Parameters, Default values and Attributes

Command

    az deployment group create --resource-group testrg --template-file .\3.strgacct.bicep  --parameters accessTier='Hot' kind='StorageV2'
