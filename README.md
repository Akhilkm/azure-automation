# BIS-Infrastructure
BIS infrastructure repository

# Naming convention
Project-Environment-extension

Environment | Resource Name     |
------------|-------------------|
Production  | bis-prod          |
------------|-------------------|
QA          | bis-qa            |
------------|-------------------|
Test        | bis-test          |
------------|-------------------|
Devopment   | bis-dev           |

Docker Registry Naming

Environment | Resource Name     |
------------|-------------------|
Production  | bisprod          |
------------|-------------------|
QA          | bisqa            |
------------|-------------------|
Test        | bistest          |
------------|-------------------|
Devopment   | bisdev           |

# Steps to create infra
```
./DevOps_Scripts/arm-templates/deploy.sh -o all
```

# Steps to create CI/CD infra
```
Createing kubernetes namespace
kubectl create bis-dev

Create secrets in kubernets (if security enabled.)
kubectl create secret generic appsettings --from-file=./appsettings.json -n "<< k8s workspace >>"

Create Service connection for Docker registry (bis-dev/ bis-qa..)

Create Enivronment in pipeline (bis-infra => create multiple values (bis-dev/ bis-qa..))

Create the pipeline
```