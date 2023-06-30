pipeline {
    agent any
    
    
    
    stages {

        stage('CLEAN_WORKSPACE') {
            steps {
               cleanWs()
            }
        }
        
        stage('Clone') {
            steps {
                git branch: 'Cloudfront', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                echo "Клонированный репозиторий находится в папке: ${WORKSPACE}"
            }
        }

        stage("AWS_Terraform"){
            stages{
                stage("Terraform_Init & Plan"){
                    steps{
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'MainAcademy_AWS_key',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                            sh 'terraform init'
                            sh 'terraform plan'
                            //sh "terraform apply -auto-approve"
                            sh "terraform destroy -auto-approve"
                            echo 'ok'
                        }
                    }
                }
            }
        }
    }
}

/*
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::site-origin-mainacademy/*"
    }
  ]
}

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "3",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::284532103653:user/MainAcademy_project"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::site-origin-mainacademy/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceArn": "arn:aws:cloudfront::284532103653:distribution/E1NMRN2OUSEBFY"
                }
            }
        }
    ]
}
*/