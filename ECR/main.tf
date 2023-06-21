resource "aws_ecr_repository" "my_repository" {
  name = "${var.ECR_Repo_Name}"  

  image_tag_mutability = "${var.Tag_Mutability}" 
  
  image_scanning_configuration {
    scan_on_push = true
  }
}