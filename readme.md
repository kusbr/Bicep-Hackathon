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
3. References: links to bicep concepts used
4. Command - az cli command to submit the bicep (to be run within a terminal in the path where the bicep file exists)
5. Outputs - check the resource[s] provisioned by the command
6. Key Points - Bicep concepts used in the exercise

_In the bicep files for the exercises, you can refer the "TIP:" comment to complete the required steps._

***

## Exercise A: Basic Deployment (Provision a new ResourceGroup)

Bicep File: **Exercises/rg.bicep**

Steps:

1. Set subscription scope
2. Add location parameter to accept azure region for the resource group
3. Set the resource type to 'Microsoft.Resources/resourceGroups@2021-04-01'
4. Pass the location parameters to the resource

References:

- [VSCode bicep resource snippet](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/quickstart-create-bicep-use-visual-studio-code?tabs=CLI#add-resource-snippet)
- [Bicep file structure](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/file#bicep-format)
- [Scope](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/file#target-scope)
- [Parameters](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters)

Command:

    az deployment sub create --location 'southindia' --parameters name='testrg' location='centralindia' --template-file .\rg.bicep

_Tip: Pass the --location value different from the location parameter_

Outputs:

Check if the new resource group is created

Key Points:

- Bicep scope - note subscription targetScope
- --location deployment parameter is for the ARM service location
- location bicep parameter is passed to resource
- Observe idempotent operation (run command twice)

***

## Exercise B: Incremental resource updation -  Add Tags to Resource group

Bicep File: **Exercises/rg-tags.bicep**

Steps:

1. Add tags (name value pairs) to thetags parameter
2. Set the tags to the resource

References:

- Bicep [Object datatype](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/data-types#objects)
- Bicep [Idempotent/ Repeatable Results](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep#benefits-of-bicep)

Command:

_Tip: Add a resource like storage account in the RG before executing command

    az deployment sub create --location 'southindia' --parameter name='testrg' location='centralindia' tags="{'purpose':'learn', 'event':'MCI-India-AzBicepHackathon-31Mar22'}"  --template-file .\rg-tags.bicep

Output:

- Resource group tags added
- No changes to existing resources

Key Points:

- Incremental resource updates (as supported by the resource provider)

***

Note:
_ You will now proceed to provision a Linux VM by following the remaining exercises

# Provisioning a Linux Virtual machine

## Exercise C: Virtual Network

Bicep File: **Exercises/Modules/1.vnet.rg**

Steps:

1. Add addressSpace under VNET resource properties
2. Add subnets under VNET resource properties
3. Set subnetid output value

References:

- VNET [Properties](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks?tabs=bicep#virtualnetworkpropertiesformat)
- VNET [AddressSpace](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks?tabs=bicep#addressspace)
- VNET Subnets - array of [subnet](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks?tabs=bicep#subnet)
- Bicep [loop an array using 'for'](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/loops#array-elements)

Command:

    az deployment group create --resource-group testrg --template-file  .\1.vnet.bicep

Output:

- VNET resource is created with two subnets and specified address space

Key Points:

- Use of resource group scope in the command
- Virtual network resource template
- Bicep for loop

***

## Exercise D: Network Security Group

Bicep File: **Exercises/Modules/2.nsg.bicep**

Steps:

1. No changes to the bicep file
2. Observe the security rules property for the NSG

References:

- [NSG resource template format](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/networksecuritygroups/securityrules?tabs=bicep#template-format)

Command:

    az deployment group create --resource-group testrg --template-file  .\2.nsg.bicep

Output:

- NSG resource is created with the security rule to allow SSH port for the VNET address space

***

## Exercise E: Use modules to provision NIC and Virtual Machine

Bicep Files:

- Exercises/lab.bicep
- Exercises/Modules/4.linuxvm.bicep

Steps (Modules/4.linuxvm.bicep):

1. Familiarise yourself with the virtual machine resource template used in the module
2. For the virtualmachine resource osProfile properties, set the linuxConfiguration to use password authentication scheme

Steps (lab.bicep):

NIC provisioning:

3. Complete the Bicep code to reference the NSG resource created in the previous exercise (use the [existing](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/existing-resource) keyword and the NSG resource name)

4. Add Bicep code to use the NIC resource defined in the NIC module
('Modules/3.nic.bicep')

5. Set the module properties nsgId and subnetId to the corresponding ids (existing resource implicit references)

VM:

6. Add a new parameter called 'adminPassword' of type [securestring](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/data-types#secure-strings-and-objects) (Do not
set any default value)

7. Add bicep code to create linux VM using the module ./Modules/4.linuxvm.bicep and pass the requisite params

References:

- [Bicep Modules](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules)

- [NIC Bicep template format](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/networkinterfaces?tabs=bicep#template-format)
- [Virtual Machine Bicep template format](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines?tabs=bicep#template-format)

- [Resource dependencies in Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/resource-dependencies)
- Bicep [Datatypes](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/data-types), [Functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions) and [Operators](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/operators)

Command:

    az deployment group create --resource-group testrg --template-file  .\lab.bicep

_You will be prompted to enter adminPassword. Provide a suitable strong pasword per Azure guidelines_

Outputs:

- NIC resource is created and associated with the referenced NSG and Subnet
- Linux VM is provisioned with the profile configurations set in the bicep modules and the parameters passed

Key Points:

- Use of modules to create structured and reusable bicep templates
- @Secure attribute to accept protected parameters (commandline / parameter file/ pipeline vars)
- Virtual machine template and dependencies (subnet, vnet, nic, nsg)

***

## Exercise F: Bastion host and associated public IP

Bicep File: **Exercises/Modules/5.publicIP.bicep**
Bicep File: **Exercises/Modules/6.bastion.bicep**

Steps:

1. Run the command to provision publicIP from the module

2. Run the command to provision Bastion host from the module

Command:

    az deployment group create --resource-group testrg --template-file  .\5.publicIP.bicep

    az deployment group create --resource-group testrg --template-file  .\6.bastion.bicep

Output:

- Bastion resource is created with the public IP associated
- Connect the linux vm with bastion and the provided password

***
