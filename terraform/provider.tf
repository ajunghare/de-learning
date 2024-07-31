terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.38.0"
    }
  }
}

provider "google" {
  credentials = "/Users/aj383k/.dbt/my-creds.json"
  project = "ee-india-se-data"
  region  = "asia-south1"
}
