pipeline {
    agent any
    
    stages {
        stage('Clone') {
            steps {
                git branch: 'Add-instance', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
            }
        }

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