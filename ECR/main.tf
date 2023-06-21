resource "aws_ecr_repository" "my_repository" {
  name = "${var.ECR_Repo_Name}"  

  image_tag_mutability = "${var.Tag_Mutability}" 
  scan_on_push         = true       # Опционально, активируйте сканирование образов при пуше
}