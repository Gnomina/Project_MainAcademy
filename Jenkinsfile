pipeline {
    agent any

    //parameters {
    //    string(name: 'GIT_BRANCH_OR_TAG', defaultValue: 'main', description: 'Specify the Git branch or tag to build')
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
                echo "PATH to clone repo: ${WORKSPACE}"
                script {
                    def branchName = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
                    env.git_branch = branchName
                    def repositoryName = sh(returnStdout: true, script: 'git remote show origin -n | grep "Fetch URL:" | awk -F/ \'{print $NF}\' | sed -e "s/.git$//"').trim().toLowerCase()
                    env.repository_name = repositoryName
                } 

            }
        }
        
        stage('Build and Push Image') {
        environment {
            ECR_REGISTRY = '284532103653.dkr.ecr.eu-central-1.amazonaws.com/docker_image'
            IMAGE_NAME = "${env.repository_name}"
            }
            steps { //assemble and push docker image
                sh "docker build -t ${env.repository_name} -f ${WORKSPACE}/webapp/Dockerfile ."
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        sh "aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                        sh "docker tag ${env.repository_name}:${env.git_branch} ${ECR_REGISTRY}"
                        sh "docker push ${ECR_REGISTRY}"

                    }
                }
            }
        }
    }
}


//sh "docker login -u AWS -p ${pass} public.ecr.aws/p7o7q6w7"



                        //sh 'aws ecr get-login-password --region eu-central-1'
                        //sh 'aws ecr --region eu-central-1 | docker login -u AWS -p --password-stdin public.ecr.aws/p7o7q6w7'
                        //sh 'eval $(aws ecr get-login --no-include-email --region eu-central-1)'
                        //sh "docker login -u AWS -p ${AWS_ACCESS_KEY_ID} public.ecr.aws/public.ecr.aws/p7o7q6w7"
                        //sh "docker login -u AWS -p \$(aws ecr-public get-login-password --region us-east-1) public.ecr.aws/p7o7q6w7"
                        //sh "aws ecr-public get-login-password --region ueu-central-1 | docker login --username AWS --password-stdin public.ecr.aws/p7o7q6w7"
                        //sh 'docker tag $IMAGE_NAME $ECR_REGISTRY/$IMAGE_NAME'
                        //sh 'docker push $ECR_REGISTRY/$IMAGE_NAME'


//sh "aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 284532103653.dkr.ecr.eu-central-1.amazonaws.com"
                     
