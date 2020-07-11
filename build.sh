#!/bin/bash


export repo_project=bis-backend-app
export DeploymentTime=$(date +%F--%H-%M-%S--%Z)

export bis_backend_app_replicas=1
export bis_backend_app_backbone="dotnet EPIC.BIS.API.Core.dll"
export ACR_ENDPOINT=bisdevelop.azurecr.io
export image="bisdevelop.azurecr.io/bis-backend-core-app:5"
export K8S_NAMESPACE="bis-develop"


envsub < ./K8s-Infra/K8s-Deployment/bis-backend-app-deployment.yaml
