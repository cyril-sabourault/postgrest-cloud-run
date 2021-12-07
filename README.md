# Expose your Postgres database on Cloud SQL easily with Cloud Run
The [PostgREST][postgrest-doc] project provides a CRUD API on top of your postgres database.  
What better way to explore your data than with an OpenAPI running on Cloud Run?

## Overview
Thanks to Cloud Run easy integration with Cloud SQL and Secret Manager it's very easy to connect all we need!  

> Your data in Cloud SQL  
> ↕️  
> VPC Connector  
> ↕️  
> SQL Connection  
> ↕️  
> Cloud Run service

## Content
This repo serves as a demo, it will:
- Create a Cloud SQL instance with Postgres in a private VPC.  
- Set the `postgres` password and store it in Secret Manager  
- Initialize a Cloud Run Service, with a VPC Connector, a SQL Connection to the SQL instance, and mounting the password from Secret  
- Finally, output the Service Endpoint  

Exemple:
![swagger preview][docs-swagger-preview]

> **/!\\ Permission**: the resulting Cloud Run service is available publicly for easy of access

```
.
├── cloud_run
│   ├── cloud_run.tf
│   ├── outputs.tf
│   └── variables.tf
│
├── cloud_sql
│   ├── outputs.tf
│   ├── postgres.tf
│   └── variables.tf
│
├── secret_manager
│   ├── outputs.tf
│   ├── secret_manager.tf
│   └── variables.tf
│
├── backend.tf
└── main.tf
```


## Deploy
Authenticate
```
gcloud auth application-default login
```

```
tf {init,plan,apply}
```

[postgrest-doc]: https://postgrest.org
[docs-swagger-preview]: docs/swagger-preview.png