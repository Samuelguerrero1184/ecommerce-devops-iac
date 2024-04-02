resource "github_repository" "tf_repo" {
  name        = "ecommerce-devops-iac"
  description = "Repo for Terraform modules"
  visibility  = "public"
  
}

resource "github_branch" "local_1" {
  repository = "ecommerce-devops-iac"
  branch     = "local_samuel"
}
resource "github_branch" "local_2" {
  repository = "ecommerce-devops-iac"
  branch     = "local_santiago"
}
resource "github_branch" "local_3" {
  repository = "ecommerce-devops-iac"
  branch     = "local_esteban"
}