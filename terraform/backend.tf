terraform {
  backend "gcs" {
    bucket = "devops-portfolio-499605-tfstate"
    prefix = "book-review-app"
  }
}