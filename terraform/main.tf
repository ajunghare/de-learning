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
# ###this was one time creation as later on deployment is handled via githubActions 
# resource "google_storage_bucket" "cloud-function-bucket" {
#   name                     = "se-data-cloudfunction-ajit"
#   location                 = "ASIA-SOUTH1"
#   force_destroy            = true
#   public_access_prevention = "enforced"

#   lifecycle_rule {
#     condition {
#       age = 1
#     }
#     action {
#       type = "AbortIncompleteMultipartUpload"
#     }
#   }
# }


# data "archive_file" "functionZip" {
#   type = "zip"
#   output_path = "../cloud_functions/rating_loader.zip"
#   source_dir =  "../cloud_functions/ratings_loader"
# }

# resource "google_storage_bucket_object" "archive" {
#   name = "rating_loader_function.zip"
#   bucket = google_storage_bucket.cloud-function-bucket.name
#   source = "../cloud_functions/rating_loader.zip"

#   depends_on = [ data.archive_file.functionZip ]
# }

# resource "google_cloudfunctions_function" "ratings_loader" {
#   name = "ratings_loader"
#   runtime = "python312"
#   source_archive_bucket = google_storage_bucket.cloud-function-bucket.name
#   source_archive_object = google_storage_bucket_object.archive.name
#   event_trigger {
#     resource = google_storage_bucket.landing-bucket.name
#     event_type = "google.storage.object.finalize"
#   }
  
#   depends_on = [ google_storage_bucket_object.archive ]
# }
