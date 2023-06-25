pipeline {
    agent any
    
    parameters {
        string(name: 'INSTANCE_COUNT', description: 'Instance Count to start')
        string(name: 'INSTANCE_TAG', description: 'Instance Tag')
    }
    
    stages {

        stage('CLEAN_WORKSPACE') {
            steps {
               cleanWs()
            }
        }
        
        stage('Clone') {
            steps {
                git branch: 'Parametr-start-instance', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
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
                            sh "terraform apply -auto-approve -var 'instance_count=${params.INSTANCE_COUNT}' -var 'instance_tag=${params.INSTANCE_TAG}'"
                            echo 'ok'
                        }
                    }
                } 
            }
        }
    }
}