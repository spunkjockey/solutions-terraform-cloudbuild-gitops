resource "google_storage_bucket" "cloud_function_bucket" {
  name     = "cloud-function-${var.env}-bucket"
  location = var.region
  project  = var.project
}

resource "google_storage_bucket" "input_bucket" {
  name     = "input-${var.env}-bucket"
  location = var.region
  project  = var.project
}