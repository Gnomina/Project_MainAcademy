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
                withCredentials([sshUserPrivateKey(credentialsId: "12345", 
                keyFileVariable: 'KEY_PATH', usernameVariable: 'REMOTE_USER')]) {
                    sh "ssh-keyscan 3.73.91.12 >> ~/.ssh/known_hosts"
                    sh 'ansible-playbook -i ${WORKSPACE}/ansible/inventory.ini
                        ${WORKSPACE}/ansible/playbook.yml --user=${REMOTE_USER} --key-file=${KEY_PATH}'
                }
            }
        }
    }
}