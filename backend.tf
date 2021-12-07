terraform {
  backend "gcs" {
    bucket = "ce1af669828801e8d5b5208a5961e4b3"
    prefix = "terraform/state/postgrest"
  }
}
