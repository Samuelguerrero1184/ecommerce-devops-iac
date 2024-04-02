terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

}


# Configure the GitHub Provider
provider "github" {
    token = "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"
}
  