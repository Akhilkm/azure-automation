#!/bin/bash

kubectl create ns bis-dev

az devops login --organization kuberiter

az pipelines create --name bis-frontend-app --description 'Pipeline for bis-frontend-app project' \
                    --repository bis-frontend-app --branch dev --repository-type tfsgit \
                    --project EPIC-TestRun --organization https://dev.azure.com/kuberiter/ \
                    --skip-first-run true --yaml azure-pipelines.yml



