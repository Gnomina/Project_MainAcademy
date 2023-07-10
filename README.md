# Project_MainAcademy
Project at MainAcademy 


Start instanse to create AMI image. After create image, create ELB and ASG (and other needed parts) to create WebApp server-stack
Ansible module install needed packages(AWS SLI, ClamAV, Docker). Ansible dynamic inventory use tag "env"
On Start_instance block, after create instanse, used "user data" to upload bash script in instanse.


create ASG
https://www.youtube.com/watch?v=9Z0heLHN2Xk&ab_channel=e2eSolutionArchitect
https://github.com/e2eSolutionArchitect/terraform/tree/main/providers/aws/projects/e2esa-aws-ec2-autoscaling
https://www.youtube.com/watch?v=dI7d48UsVyc&ab_channel=S3CloudHub



