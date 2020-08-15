#!/bin/bash

# Common variables
SUBSCRIPTION_ID="3f28f233-01b4-4f88-88aa-903f54eb850f"
DATE_STRING=$(date +%Y%m%d%H%M%S%Z)

# Resource group variables
RESOURCE_GROUP_NAME="temp-dev"
RESOURCE_GROUP_LOCATION="eastus"

# Network variables
VNET_NAME=$RESOURCE_GROUP_NAME
VNET_LOCATION=$RESOURCE_GROUP_LOCATION
NETWORK_PREFIX="10.1"

# ACR variables
REGISTRY_NAME="tempdev"
PUBLIC_NETWORK_ACCESS="Enabled"
REGISTRY_SKU="Standard"
REGISTRY_LOCATION=$RESOURCE_GROUP_LOCATION

# AKS variables
AKS_RESOURCE_NAME=$RESOURCE_GROUP_NAME
AKS_LOCATION=$RESOURCE_GROUP_LOCATION
AKS_VERSION="1.16.10"
AKS_SERVICE_CIDR="10.8.0.0/16"   # Do not overlap with VNET CIDR
AKS_DNS_IP="10.8.0.10"  # Should be in AKS_SERVICE_CIDR
AKS_SERVICEPRINCIPAL_NAME="tempDevK8SServicePrincipal"
AKS_WORKSPACE_NAME=${RESOURCE_GROUP_NAME}-k8s-workspace-${DATE_STRING}
AKS_VNET_SUBNETID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/${VNET_NAME}/subnets/${RESOURCE_GROUP_NAME}-privatesubnet1"
AKS_OMS_WORKSPACEID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${AKS_WORKSPACE_NAME}"

# Function to set subscription
function setSubscription() {
    echo "Setting up the subscription"
    az account set --subscription ${SUBSCRIPTION_ID}
}

# Function to create Resource Group
function createResourceGroup() {
    echo "Creating the resource group"
    az deployment sub create --location ${RESOURCE_GROUP_LOCATION} --template-file ./temp-rg-arm.json \
        --name ${RESOURCE_GROUP_NAME}-rg-deployment --parameters \
        rgName=${RESOURCE_GROUP_NAME} rgLocation=${RESOURCE_GROUP_LOCATION} 
}

# Function to create Network resources
function createNetwork() {
    echo "Creating the network infrastructure"
    az deployment group create --resource-group ${RESOURCE_GROUP_NAME}  \
        --template-file ./temp-network-arm.json \
        --name ${RESOURCE_GROUP_NAME}-nw-deployment --parameters \
        vnetName=${VNET_NAME} ipAddressPrefix=${NETWORK_PREFIX} \
        resourceLocation=${VNET_LOCATION}
}

# Function to create container registry
function createContainerRegistry() {
    echo "Creating the container registry"
    az deployment group create --resource-group ${RESOURCE_GROUP_NAME}  \
        --template-file ./temp-registry-arm.json \
        --name ${RESOURCE_GROUP_NAME}-registry-deployment --parameters \
        registryName=${REGISTRY_NAME} registryLocation=${REGISTRY_LOCATION} \
        registrySku=${REGISTRY_SKU} publicNetworkAccess=${PUBLIC_NETWORK_ACCESS}

}

# Function to create Kubernetes cluster
function createAksCluster() {
    echo "Creating the AKS Service principal"
    output=$(az ad sp create-for-rbac --skip-assignment --name ${AKS_SERVICEPRINCIPAL_NAME})
    appId=$(echo $output | jq -r '.appId')
    appSecret=$(echo $output | jq -r '.password')

    output=$(az ad sp list --display-name ${AKS_SERVICEPRINCIPAL_NAME})
    objectId=$(echo $output | jq -r '.[].objectId')

    echo "Creating the AKS cluster"
    sleep 10
    omsWorkspaceId=$AKS_OMS_WORKSPACEID
    vnetSubnetID=$AKS_VNET_SUBNETID

    az deployment group create --resource-group ${RESOURCE_GROUP_NAME}  \
        --template-file ./temp-k8s-arm.json \
        --name ${RESOURCE_GROUP_NAME}-k8s-deployment --parameters resourceGroup=${RESOURCE_GROUP_NAME} \
        resourceName=${AKS_RESOURCE_NAME} location=${AKS_LOCATION} \
        kubernetesVersion=${AKS_VERSION} servicePrincipalClientId=${appId} \
        servicePrincipalClientSecret=${appSecret} principalId=${objectId} \
        omsWorkspaceId=${omsWorkspaceId} vnetSubnetID=${vnetSubnetID} \
        workspaceName=${AKS_WORKSPACE_NAME} workspaceRegion=${AKS_LOCATION} \
        serviceCidr=${AKS_SERVICE_CIDR} dnsServiceIP=${AKS_DNS_IP}
}

# Function to create integration between ACR and AKS
function acraksIntegration() {
    echo "Creating ACR - AKS integration"
    az aks update -n ${AKS_RESOURCE_NAME} -g ${RESOURCE_GROUP_NAME} --attach-acr ${REGISTRY_NAME}
}

# Function to cleanup all the resources
function cleanUp() {
    echo "Starting the cleanup"
    az group delete -n ${RESOURCE_GROUP_NAME}
    output=$(az ad sp list --display-name ${AKS_SERVICEPRINCIPAL_NAME})
    objectId=$(echo $output | jq -r '.[].objectId')
    az ad sp delete --id $objectId

    az deployment sub delete -n ${RESOURCE_GROUP_NAME}-rg-deployment
}

export Command_Usage="Usage: ./deploy.sh -o [OPTION...]"

while getopts ":o:" opt
   do
     case $opt in
        o ) option=$OPTARG;;
     esac
done


if [[ $option = all ]]; then
    setSubscription
    createResourceGroup
    createNetwork
    createContainerRegistry
    createAksCluster
    acraksIntegration
elif [[ $option = createResourceGroup ]]; then
    setSubscription
    createResourceGroup
elif [[ $option = createNetwork ]]; then
    setSubscription
    createNetwork
elif [[ $option = createContainerRegistry ]]; then
    setSubscription
    createContainerRegistry
elif [[ $option = createAksCluster ]]; then
    setSubscription
    createAksCluster
elif [[ $option = acraksIntegration ]]; then
    setSubscription
    acraksIntegration
elif [[ $option = cleanUp ]]; then
    cleanUp
else
	echo "$Command_Usage"
cat << EOF
_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
Main modes of operation:
all                            :   Create all the resouces
createResourceGroup            :   Create resource group
createNetwork                  :   Create network infrastructure
createContainerRegistry        :   Create container registry
createAksCluster               :   Crete AKS cluster
acraksIntegration              :   Create AKS - ACR integration
cleanUp                        :   Deleting all the resources
_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
EOF
fi