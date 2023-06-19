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
        stage('Build and Push Image') {
        environment {
            ECR_REGISTRY = 'public.ecr.aws/p7o7q6w7/test-aws-ecr'
            IMAGE_NAME = 'test_webapp'
            }
            steps { //assemble and push docker image
                sh "docker build -t $IMAGE_NAME -f ${WORKSPACE}/webapp/Dockerfile ."
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        sh 'docker tag $IMAGE_NAME $ECR_REGISTRY/$IMAGE_NAME'
                    sh 'docker push $ECR_REGISTRY/$IMAGE_NAME'

                    }
                }
            }
        }
    }
}