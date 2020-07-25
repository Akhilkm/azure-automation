# TEMP-Infrastructure
TEMP infrastructure repository

# Naming convention
Project-Environment-extension

Environment | Resource Name     |
------------|-------------------|
Production  | temp-prod          |
QA          | temp-qa            |
Test        | temp-test          |
Devopment   | temp-dev           |

Docker Registry Naming

Environment | Resource Name     |
------------|-------------------|
Production  | tempprod           |
QA          | tempqa             |
Test        | temptest           |
Devopment   | tempdev            |

Git Branch Naming

Docker Registry Naming

Environment | Resource Name     |
------------|-------------------|
Production  | master            |
QA          | qa                |
Test        | test              |
Devopment   | dev               |

# Steps to create infra
```
./DevOps_Scripts/arm-templates/deploy.sh -o all
```

# Steps to create CI/CD infra
```
Copy the required files and folders from infra repo.

Create Service connection for Docker registry (temp-dev/ temp-qa..)

Create Enivronment in pipeline (temp-infra => create multiple values (temp-dev/ temp-qa..))

Create the pipeline
```