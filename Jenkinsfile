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
                ansibleplaybook playbook: 'playbook.yml', inventory: 'inventory.ini',
                colorized: true, credentialsId: 'Ansible_ssh_key'
        }
    }
}