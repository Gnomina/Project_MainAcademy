pipeline {
    agent any
    
    
    
    parameters {
       string(name: 'Input Branch Name (Dev or Prod)', defaultValue: 'Dev', description: 'Uploading files from a specific branch to s3 bucket')
    }
    
    stages {
        

        stage('CLEAN_WORKSPACE') {
            steps {
               cleanWs()
            }
        }
//---------------------------------------------------------GITHUB---------------------------------------------------------------------------------------
        stage('Clone') {
            steps {
                git branch: "${params['Input Branch Name (Dev or Prod)']}", credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                //git branch: "WebApp", credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                script{
                    def branchName = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
                    def repositoryName = sh(returnStdout: true, script: 'git remote show origin -n | grep "Fetch URL:" | awk -F/ \'{print $NF}\' | sed -e "s/.git$//"').trim().toLowerCase()
                    env.repository_name = repositoryName     
                    env.work_branch = branchName
                    env.downloaded_branch = "${params['Input Branch Name (Dev or Prod)']}"
                    echo "PATH to clone repo: ${WORKSPACE}"
                    echo "Repository name: ${env.repository_name}"
                    echo "Branch name: ${env.work_branch}"
                    echo "downloaded_branch: ${env.downloaded_branch}"
                }
                
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
                           
                        }
                    }
                }
            }
        }
    }
}

