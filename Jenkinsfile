pipeline {
    agent any

    parameters {
        string(name: 'Input Branch Name', defaultValue: 'main', description: 'Specify the Git branch build')
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
                git branch: "WebApp", credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                script{
                    def branchName = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
                    def repositoryName = sh(returnStdout: true, script: 'git remote show origin -n | grep "Fetch URL:" | awk -F/ \'{print $NF}\' | sed -e "s/.git$//"').trim().toLowerCase()
                    env.repository_name = repositoryName     
                    env.git_branch = branchName
                    echo "PATH to clone repo: ${WORKSPACE}"
                    echo "Repository name: ${env.repository_name}"
                    echo "Branch name: ${env.git_branch}"
                }
                
            }
        }
        stage('Build and Push Image') {
            environment {
                def ECR_REGISTRY = '284532103653.dkr.ecr.eu-central-1.amazonaws.com/docker_image'
            }
            steps { 
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        
                        sh "docker build -t ${env.repository_name}:${env.git_branch} -f ${WORKSPACE}/webapp/Dockerfile ."
                        sh "aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin ${env.ECR_REGISTRY}"
                        
                        sh "docker tag ${env.repository_name}:${env.git_branch} ${env.ECR_REGISTRY}:${env.git_branch}"
                        sh "docker push ${env.ECR_REGISTRY}:${env.git_branch}"

                    }
                }
            }
        }
    }
}


                     