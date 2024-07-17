terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.38.0"
    }
  }
}

provider "google" {
  # credentials = "./keys/my-creds.json"
  project = "ee-india-se-data"
  region  = "asia-south1"
}

resource "google_storage_bucket" "landing-bucket" {
  name                     = "se-data-landing-ajit"
  location                 = "ASIA-SOUTH1"
  force_destroy            = true
  public_access_prevention = "enforced"
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}