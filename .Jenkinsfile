pipeline {
    agent any
    
    stages {
        stage('Clone') {
            steps {
                git branch: 'Add-instance', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
            }
        }
        
        stage('Get Terraform Variable') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        def tfStateFile = sh(script: "aws s3 cp s3://mainacademy-project-terraform-back/dev/backend/terraform.tfstate -", returnStdout: true).trim()// url or ARN
                        def tfStateJson = readJSON(text: tfStateFile)
                        def id = tfStateJson.outputs.instance_id.value
                        echo "ID = ${id}"
                        env.instance_id = id //create environment variable - env.instance_id
                    }                      
                }       
            }
            
        }

        stage("Destroy Infrastructure"){
            steps{
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    sh 'terraform init'
                    sh "terraform plan -destroy -target=aws_instance.${env.instance_id}"
                    sh "terraform destroy -target=aws_instance.${env.instance_id} -state=s3://dev/backend/terraform.tfstate "
                    echo 'ok'
                }
            }
        }
    }
}