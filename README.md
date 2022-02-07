# Expose your Postgres database on Cloud SQL easily with Cloud Run 
The [PostgREST][postgrest-doc] project provides a CRUD API on top of your postgres database.  
What better way to explore your data than with an OpenAPI running on Cloud Run?

## Overview
Thanks to Cloud Run easy integration with Cloud SQL and Secret Manager it's very easy to connect all we need!  


<center>

> Your data in Cloud SQL  
> ↕️  
> VPC Connector  
> ↕️  
> SQL Connection  
> ↕️  
> Cloud Run service

</center>


<br/>

## Content of this repo 🕵🏻
This repo serves as a demo, it will:
- Create a Cloud SQL instance with Postgres in a private VPC.  
- Set the `postgres` password and store it in Secret Manager  
- Initialize a Cloud Run Service, with a VPC Connector, a SQL Connection to the SQL instance, and mounting the password from Secret  
- Finally, output the Service Endpoint and optional gcloud commands to populate the database  


> **/!\\ Permission**: the resulting Cloud Run service is available publicly for ease of access

<br/>

Exemple of deployed interface ⤵️
![swagger preview][docs-swagger-preview]

Exemple generated openapi spec:
[openapi.json][openapi-json]

<br/>


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
└── main.tf
├── example.tfvars
└── [backend.tf]
```


## Deploy 🚀
Authenticate first using gcloud's ADC
```sh
gcloud auth application-default login
```

Fill in your own GCP project id in the `example.tfvars` file.  
[Optionnaly, uncomment the `backend.tf` file and fill in your GCS bucket name if you want a remote state.]


Deploy! 
```sh
tf init
tf plan -var-files=example.tfvars -out tfplan

# (the tf apply will start immediately,
#+ you better review the tf plan output first)
tf apply tfplan
```


Go grab a coffee while Terraform is doing its magic ☕️ ✨  

Come back to Terraform outputting gcloud commands to populate the db and the service URL to inspect your data! 🔍 👀  


## Cleanup 🧹
Set the _`deletion_protection`_ field in `cloud_sql/postgres.tf` to _`false`_ on the SQL Database instance:


<pre>
  resource "google_sql_database_instance" "postgrest" {
    &nbsp;&nbsp;<small>(...)</small>
    &nbsp;&nbsp;deletion_protection = <em>true</em> -> <em>false</em>
    &nbsp;&nbsp;<small>(...)</small>
  }
</pre>


Apply the change
```sh
tf apply -var-file=example.tfvars \
  -target module.postgrest_database.google_sql_database_instance.postgrest
```

Confirm you want to delete all resources
```sh
tf destroy
```


[postgrest-doc]: https://postgrest.org
[docs-swagger-preview]: docs/swagger-preview.png
[openapi-json]: docs/openapi.json
