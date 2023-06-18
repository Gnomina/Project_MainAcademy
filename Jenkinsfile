pipeline {
    agent any
    
    stages {
        stage("Destroy Infrastructure"){
            steps{
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    sh 'terraform init'
                    sh 'terraform plan -destroy'
                    sh 'terraform destroy -state=s3://dev/backend/terraform.tfstate'
                    echo 'ok'
                }
            }
        }
    }
}