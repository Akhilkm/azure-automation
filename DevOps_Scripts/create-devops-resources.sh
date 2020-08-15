#!/bin/bash

kubectl create ns temp-dev

az devops login --organization kuberiter

az pipelines create --name temp-frontend-app --description 'Pipeline for temp-frontend-app project' \
                    --repository temp-frontend-app --branch dev --repository-type tfsgit \
                    --project PJT-TestRun --organization https://dev.azure.com/kuberiter/ \
                    --skip-first-run true --yaml azure-pipelines.yml



