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
                git branch: 'main', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                echo "Клонированный репозиторий находится в папке: ${WORKSPACE}"
            }
        }
        stage("AWS_Terraform"){
            stages{
                stage("Terraform_Init"){
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
                stage("Terraform_Plan"){
                    steps{
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                        credentialsId: 'MainAcademy_AWS_key',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                            sh "terraform plan"
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
                            echo 'ok'
                         }
                    }
                } 
                stage('Terraform Destroy') {
                   steps {
                    script {
                        // Ожидание ввода от пользователя
                        def userInput = input(
                            id: 'destroyInput',
                            message: 'Destroy resources?',
                            parameters: [booleanParam(defaultValue: false, description: 'Select true to destroy resources')]
                            )

                            if (userInput.destroyInput) {
                                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                credentialsId: 'MainAcademy_AWS_key',
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                                    sh "terraform destroy -auto-approve"
                                    echo 'Delete ok'
                                    } 
                            else {
                                echo 'Skipping resource destruction.'
                                }   
                            }
                       }
                    }
                }
            }
        }
    }
} 
        
    
    

    
        