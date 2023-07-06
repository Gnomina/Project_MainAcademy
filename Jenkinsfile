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
                git branch: 'app_stack', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                echo "Cloned repository PATH: ${WORKSPACE}"
            }
        }

        stage("AWS_Terraform"){
            steps{
                sh "pwd"
                dir("${WORKSPACE}/Start_instance") {
                    sh "pwd"
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'MainAcademy_AWS_key',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                        sh "pwd"
                        sh 'terraform init'
                        sh 'terraform plan'
                        sh "terraform apply -auto-approve"
                        echo 'ok'
                    }
                }
            }
        }
    }
}

