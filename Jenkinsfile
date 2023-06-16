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
                git branch: 'ClamAV-antimailware', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                echo "Клонированный репозиторий находится в папке: ${WORKSPACE}"
            }
        }

        stage('Run Ansible playbook') {
             steps {
                withCredentials([sshUserPrivateKey(credentialsId: "key", 
                keyFileVariable: 'KEY_PATH', usernameVariable: 'REMOTE_USER')]) {
                    sh 'ansible-playbook -i inventory.ini playbook.yml'
                }
            }
        }
    }
}