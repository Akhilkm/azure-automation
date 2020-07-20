# BIS-Infrastructure
BIS infrastructure repository

# Naming convention
```
Project-Environment-extension
```

Environment | Resource Name     |
------------|-------------------|
Production  | bis-prod          |
------------|-------------------|
QA          | bis-qa            |
------------|-------------------|
Test        | bis-test          |
------------|-------------------|
Devopment   | bis-dev           |

# Steps to create infra
```
./DevOps_Scripts/arm-templates/deploy.sh -o all
```

# Steps to create CI/CD infra
```
Createing kubernetes namespace
kubectl create bis-dev

Create Service connection for Docker registry

Create Enivronment in pipeline

Create the pipeline
```