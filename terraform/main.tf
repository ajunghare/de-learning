
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

resource "google_bigquery_dataset" "movies_data" {
  dataset_id                  = "movies_data_ajit"
  friendly_name               = "movies_data"
  description                 = "Dataset for movies"
  location                    = "ASIA-SOUTH1"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }
}

