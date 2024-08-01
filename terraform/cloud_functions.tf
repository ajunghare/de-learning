
data "archive_file" "functionZip" {
  type = "zip"
  output_path = "../cloud_functions/data_loader.zip"
  source_dir =  "../cloud_functions/data_loader"
}

resource "google_storage_bucket_object" "archive" {
  name = "data_loader_function.zip"
  bucket = google_storage_bucket.cloud-function-bucket.name
  source = "../cloud_functions/data_loader.zip"

  depends_on = [ data.archive_file.functionZip, google_storage_bucket.cloud-function-bucket ]
}

resource "google_cloudfunctions_function" "data_loader" {
  name = "data_loader"
  runtime = "python312"
  source_archive_bucket = google_storage_bucket.cloud-function-bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  event_trigger {
    resource = google_storage_bucket.landing-bucket.name
    event_type = "google.storage.object.finalize"
  }
  
  depends_on = [ google_storage_bucket_object.archive ]
}
