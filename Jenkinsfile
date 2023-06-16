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
                git branch: 'Add-instance', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
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
                            echo 'ok'
                        }
                    }
                }
                
                stage("Terraform_apply"){
                    steps{
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'MainAcademy_AWS_key',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                            sh "terraform apply -auto-approve"
                            sh "terraform output instance_public_ip > ${WORKSPACE}/Hosts.txt"
                            echo 'ok'
                            sh 'terraform destroy -auto-approve'
                         }
                    }
                } 
            }
        }
    }
}