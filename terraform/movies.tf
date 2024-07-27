resource "google_bigquery_table" "movies_raw" {
  dataset_id          = google_bigquery_dataset.movies_data.dataset_id
  table_id            = "movies_raw"
  deletion_protection = false
  schema              = <<EOF
    [
      {
        "name": "adult",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "adult"
      },
      {
        "name": "belongs_to_collection",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "belongs_to_collection"
      },
      {
        "name": "budget",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "budget"
      },
      {
        "name": "genres",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "genres"
      },
      {
        "name": "homepage",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "homepage"
      },
      {
        "name": "id",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "id"
      },
      {
        "name": "imdb_id",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "imdb_id"
      },
      {
        "name": "original_language",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "original_language"
      },
      {
        "name": "original_title",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "original_title"
      },
      {
        "name": "overview",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "overview"
      },
      {
        "name": "popularity",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "popularity"
      },
      {
        "name": "poster_path",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "poster_path"
      },
      {
        "name": "production_companies",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "production_companies"
      },
      {
        "name": "production_countries",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "production_countries"
      },
      {
        "name": "release_date",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "release_date"
      },
      {
        "name": "revenue",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "revenue"
      },
      {
        "name": "runtime",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "runtime"
      },
      {
        "name": "spoken_languages",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "spoken_languages"
      },
      {
        "name": "status",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "status"
      },
      {
        "name": "tagline",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "tagline"
      },
      {
        "name": "title",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "title"
      },
      {
        "name": "video",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "video"
      },
      {
        "name": "vote_average",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "vote_average"
      },
      {
        "name": "vote_count",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "vote_count"
      },
      {
        "name": "load_date",
        "type": "DATETIME",
        "defaultValueExpression": "CURRENT_DATETIME()",
        "mode": "NULLABLE",
        "description": "vote_count"
      }
    ] 
    EOF
}