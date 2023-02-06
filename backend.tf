terraform {
 backend "gcs" {
   bucket  = "kk-gcp-tf-state"
   prefix  = "terraform/state"
   credentials = "kk-tf-account.json"
 }
}
