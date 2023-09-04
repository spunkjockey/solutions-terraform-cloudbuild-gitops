// Create a Pub/Sub notification.
resource "google_storage_notification" "notification" {
  bucket         = google_storage_bucket.bucket.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.topic.id
  event_types    = ["OBJECT_FINALIZE"]
  depends_on     = [google_pubsub_topic_iam_binding.binding]
}

// Enable notifications by giving the correct IAM permission to the unique service account.
data "google_storage_project_service_account" "gcs_account" {
}

// Create a Pub/Sub topic.
resource "google_pubsub_topic_iam_binding" "binding" {
  topic    = google_pubsub_topic.topic.id
  role     = "roles/pubsub.publisher"
  members  = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

// Create a new storage bucket.
resource "google_storage_bucket" "bucket" {
  name                        = "${var.env}-${random_id.bucket_prefix.hex}-event-driven-bucket"
  location                    = "US"
}

resource "google_pubsub_topic" "topic" {
  name     = "${var.env}_${random_id.bucket_prefix.hex}_topic"
}