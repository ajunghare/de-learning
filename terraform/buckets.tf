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

resource "google_storage_bucket" "cloud-function-bucket" {
  name                     = "se-data-cloudfunction-ajit"
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
