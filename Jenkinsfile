pipeline {
    agent any
    
    environment {
        ip = ''
    }
    
    stages {

        stage('CLEAN_WORKSPACE') {
            steps {
               cleanWs()
            }
        }

        stage('Clone') {
            steps {
                git branch: 'ClamAV-antimailware', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                echo "Клонированный репозиторий находится в папке: ${WORKSPACE}"
            }
        }

        stage('Get Terraform Variable') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        def tfStateFile = sh(script: "aws s3 cp s3://mainacademy-project-terraform-back/dev/backend/terraform.tfstate -", returnStdout: true).trim()
                        def tfStateJson = readJSON(text: tfStateFile)
                        //def ip = tfStateJson.outputs.instance_public_ip.value
                        ip = tfStateJson.outputs.instance_public_ip.value
                        echo "IP = ${ip}"
                    }                      
                }       
            }
            
        }

        stage('Write Inventory') {
            steps {
                script {
                    echo "IP = ${env.ip}"
                    def inventoryFile = "${WORKSPACE}/ansible/inventory.ini"
                    sh "sed -i 's/REPLACE_WITH_IP/${env.ip}/g' ${inventoryFile}"
                }
            }
        }
    }
}   
















/*
        stage('Run Ansible playbook') {
             steps {
                withCredentials([sshUserPrivateKey(credentialsId: "12345", 
                keyFileVariable: 'KEY_PATH', usernameVariable: 'REMOTE_USER')]) {
                
                    sh "ssh-keyscan 3.73.91.12 >> ~/.ssh/known_hosts"

                    sh 'ansible all -m ping -u ${REMOTE_USER} '+
                       '-i ${WORKSPACE}/ansible/inventory.ini --private-key=${KEY_PATH}'

                    sh 'ansible-playbook -i ${WORKSPACE}/ansible/inventory.ini'+
                       ' ${WORKSPACE}/ansible/playbook.yml'+
                       ' --user=${REMOTE_USER} --key-file=${KEY_PATH}'
                }
            }
        }
    }
}
*/