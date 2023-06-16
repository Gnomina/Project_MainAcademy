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
                keyFileVariable: 'KEY_PATH', usernameVariable: 'ubuntu')]) {
                    sh "ssh-keyscan 3.73.91.12 >> ~/.ssh/known_hosts"
                    sh 'ansible-playbook -i inventory.ini playbook.yml'
                }
            }
        }
    }
}