resource "google_bigquery_table" "ratings_raw" {
  dataset_id          = google_bigquery_dataset.movies_data.dataset_id
  table_id            = "ratings_raw"
  deletion_protection = false
  schema              = <<EOF
    [
      {
        "name": "userId",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "user id"
      },
      {
        "name": "movieId",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "movie id"
      },
      {
        "name": "rating",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "rating"
      },
      {
        "name": "timestamp",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "timestamp"
      },
      {
        "name": "load_time",
        "type": "DATETIME",
        "defaultValueExpression": "CURRENT_DATETIME()",
        "mode": "NULLABLE",
        "description": "vote_count"
      }
    ] 
    EOF
}
