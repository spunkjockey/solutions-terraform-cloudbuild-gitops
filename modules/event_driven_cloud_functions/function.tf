# Generates an archiva of source code compressed as a .zip file.
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../../src/event_drive_cloud_functions"
  output_path = "${path.module}/function.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = google_storage_bucket.cloud_function_bucket.name
  depends_on = [
    google_storage_bucket.cloud_function_bucket,
    data.archive_file.source
    ]
}

# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "cloud_function" {
  name    = "cloud-function-triggered-using-terraform"
  description = "Cloud Function will get triggered once file is uploaded in input-${var.env}-bucket"
  runtime = "python39"
  project = var.project
  region = var.region
  source_archive_bucket = google_storage_bucket.cloud_function_bucket.name
  source_archive_object = google_storage_bucket_object.zip.name
  entry_point = "fileUpload"
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = "input-${var.env}-bucket"
  }
  depends_on = [
    google_storage_bucket.cloud_function_bucket,
    google_storage_bucket_object.zip
  ]
}