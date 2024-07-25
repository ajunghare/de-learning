resource "google_bigquery_dataset" "movies_data" {
  dataset_id                  = "movies_data_ajit"
  friendly_name               = "movies_data"
  description                 = "Dataset for movies"
  location                    = "ASIA-SOUTH1"
  default_table_expiration_ms = 144000000

  labels = {
    env = "default"
  }
}
