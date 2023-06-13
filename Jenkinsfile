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

        stage("AWS_Terraform") {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'MainAcademy_AWS_key',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    // Terraform Init
                    sh 'terraform init'
                    echo 'Terraform Init - OK'

                    // Terraform Plan
                    sh 'terraform plan'
                    echo 'Terraform Plan - OK'

                    // Terraform Apply
                    sh 'terraform apply -auto-approve'
                    echo 'Terraform Apply - OK'

                    // Terraform Destroy
                    script {
                        def userInput = input(
                            id: 'destroyInputId',
                            message: 'Destroy resources?',
                            parameters: [booleanParam(defaultValue: false, description: 'Select true to destroy resources')]
                            )

                        if (userInput.destroyInputId) {
                            sh 'terraform destroy -auto-approve'
                            echo 'Terraform Destroy - OK'
                        } else {
                            echo 'Skipping resource destruction.'
                        }
                    }
                }
            }
        }
    }
}
