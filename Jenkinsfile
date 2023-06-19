pipeline {
    agent any

    parameters {
        string(name: 'GIT_BRANCH_OR_TAG', defaultValue: 'main', description: 'Specify the Git branch or tag to build')
    }
    
    stages {
        

        stage('CLEAN_WORKSPACE') {
            steps {
               cleanWs()
            }
        }
        
        stage('Clone') {
            steps {
                git branch: "${params.GIT_BRANCH_OR_TAG}", credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                echo "PATH to clone repo: ${WORKSPACE}"
            }
        }

        
    }
}