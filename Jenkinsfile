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
                            sh "terraform apply -auto-approve"
                            echo 'ok'
                            script {
                                def tfStateFile = sh(script: "aws s3 cp s3://dev/backend/terraform.tfstate -", returnStdout: true)
                                def tfStateJson = readJSON(text: tfStateFile)
                                def variableValue = tfStateJson.modules[0].outputs.instance_public_ip.value

                                env.TF_VARIABLE = variableValue
                                echo "The value of TF_VARIABLE is: ${env.TF_VARIABLE}"
                            }
                        }
                    }
                } 
            }
        }
    }
}