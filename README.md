# BIS-Infrastructure
BIS infrastructure repository

# Naming convention
Project-Environment-extension

Environment | Resource Name     |
------------|-------------------|
Production  | bis-prod          |
QA          | bis-qa            |
Test        | bis-uat           |
Devopment   | bis-dev           |

Docker Registry Naming

Environment | Resource Name     |
------------|-------------------|
Production  | bisprod           |
QA          | bisqa             |
Test        | bisuat            |
Devopment   | bisdev            |

Git Branch Naming

Docker Registry Naming

Environment | Resource Name     |
------------|-------------------|
Production  | master            |
QA          | qa                |
Test        | uat               |
Devopment   | dev               |

# Steps to create infra
```
./DevOps_Scripts/arm-templates/deploy.sh -o all
```

# Steps to create CI/CD infra
```
Copy the required files and folders from infra repo.

Create Service connection for Docker registry (bis-dev/ bis-qa..)

Create Enivronment in pipeline (bis-infra => create multiple values (bis-dev/ bis-qa..))

Create the pipeline
```