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
                git branch: 'app_stack', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                echo "Cloned repository PATH: ${WORKSPACE}"
            }
        }

        stage("Create_instance"){
            steps{
                dir("${WORKSPACE}/Start_instance") {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'MainAcademy_AWS_key',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                        sh 'terraform init'
                        sh 'terraform plan'
                        sh "terraform apply -auto-approve"
                        echo 'ok'
                        script {
                            def inst_id = sh(script: "terraform output instance_id", returnStdout: true).trim()
                            echo "Instance ID: ${inst_id}"
                        }
                    }
                }
            }
        }

        /*
        stage('Instance Status Check') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        def passed = false
                        def timeoutMinutes = 5
                        def startTime = currentBuild.startTimeInMillis
                        while (!passed) {
                            def output = sh(script: "aws ec2 describe-instance-status --instance-ids ${env.instance_id} --region eu-central-1", returnStdout: true).trim()
                            def json = readJSON(text: output)

                            def server = json.InstanceStatuses[0].InstanceState.Name
                            def instanceStatus = json.InstanceStatuses[0].InstanceStatus.Details[0].Status
                            def systemStatus = json.InstanceStatuses[0].SystemStatus.Details[0].Status

                            echo "Server: ${server}"
                            echo "InstanceStatus check: ${instanceStatus}"
                            echo "SystemStatus check: ${systemStatus}"

                            if (instanceStatus == 'passed') {
                                echo "Instance status is passed. Proceeding with the pipeline..."
                                passed = true
                            } else {
                                echo "Instance is initializing. Waiting for 10 seconds..."
                                sleep 10
                            }
                            def elapsedTime = System.currentTimeMillis() - startTime
                            def timeoutMillis = timeoutMinutes * 60 * 1000

                            if (elapsedTime >= timeoutMillis) {
                                error("Server check timed out. Instance status is not passed within ${timeoutMinutes} minutes.")
                            }
                        }
                    }
                }
            }
        }*/


    }
}

