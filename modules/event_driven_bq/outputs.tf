output "bucket_name" {
  value = "${google_storage_bucket.bucket.name}"
}

output "topic_name" {
  value = "${google_pubsub_topic.topic.name}"
}