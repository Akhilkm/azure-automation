#!/bin/bash


export repo_project=temp-backend-app
export DeploymentTime=$(date +%F--%H-%M-%S--%Z)

export temp_backend_app_replicas=1
export temp_backend_app_backbone="dotnet PJT.TEMP.API.Core.dll"
export ACR_ENDPOINT=tempdevelop.azurecr.io
export image="tempdevelop.azurecr.io/temp-backend-core-app:5"
export K8S_NAMESPACE="temp-develop"


kubectl create secret generic appsettings --from-file=./appsettings.json -n "<< k8s workspace >>"

envsub < ./K8s-Infra/K8s-Deployment/temp-backend-app-deployment.yaml
