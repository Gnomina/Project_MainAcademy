pipeline {
    agent any

    //parameters {
    //    string(name: 'Input Branch Name', defaultValue: 'main', description: 'Specify the Git branch build')
    //}
    
    stages {
        

        stage('CLEAN_WORKSPACE') {
            steps {
               cleanWs()
            }
        }
        
        stage('Clone') {
            steps {
                //git branch: "${params.GIT_BRANCH_OR_TAG}", credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
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

        stage('Get Terraform Variable') { // obtaining variables with terraform S3bucet backend
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        def tfStateFile = sh(script: "aws s3 cp s3://mainacademy-project-terraform-back/dev/backend/terraform.tfstate -", returnStdout: true).trim()// url or ARN
                        def tfStateJson = readJSON(text: tfStateFile)
                        echo "TF_STATE = ${tfStateJson}"
                        //def ecr_url = tfStateJson.outputs.ecr_url.value
                        echo "ECR_URL = ${ecr_url}"
                        env.ecr_url = ecr_url //create environment variable - env.ecr_url
                    }                      
                }       
            }
            
        }
        /*
        stage('Build and Push Image') {
            
            steps { 
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        
                        sh "docker build -t ${env.repository_name}:${env.git_branch} -f ${WORKSPACE}/webapp/Dockerfile ."
                        sh "aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin ${env.ecr_url}"
                        
                        sh "docker tag ${env.repository_name}:${env.git_branch} ${env.ecr_url}:${env.git_branch}"
                        sh "docker push ${env.ecr_url}:${env.git_branch}"

                    }
                }
            }
        }*/
    }
}


                     