pipeline {
    
    agent any
        
    stages {
                
        stage('Clone') {
            steps {
                cleanWs() // clean workspace before cloning
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
                        //sh 'terraform plan'
                        sh "terraform apply -auto-approve"
                        echo 'ok'
                        script {
                            def inst_id = sh(script: "terraform output instance_id", returnStdout: true).trim()
                            def sub_id = sh(script: "terraform output subnet_id", returnStdout: true).trim()
                            def sub_name = sh(script: "terraform output subnet_name", returnStdout: true).trim()
                            def sg_id = sh(script: "terraform output sg_id", returnStdout: true).trim()
                            def vps_id = sh(script: "terraform output vpc_id", returnStdout: true).trim()
                            env.instance_id = inst_id
                            env.subnet_id = sub_id
                            env.subnet_name = sub_name
                            env.sg_id = sg_id
                            env.vpc_id = vps_id
                            echo "Instance ID: ${env.instance_id}"
                            echo "Subnet ID: ${env.subnet_id}"
                            echo "Subnet Name: ${env.subnet_name}"
                            echo "Security Group ID: ${env.sg_id}"
                            echo "VPC ID: ${env.vpc_id}"
                        }
                    }
                }
            }
        }

        
        stage('Instance Status Check and Start Ansible') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        def passed = false
                        def timeoutMinutes = 5
                        def startTime = currentBuild.startTimeInMillis
                        //---------------------------------Instance Status Check---------------------------------
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
                                echo "Instance is initializing. Waiting for 25 seconds..."
                                sleep 25
                            }
                            def elapsedTime = System.currentTimeMillis() - startTime
                            def timeoutMillis = timeoutMinutes * 60 * 1000

                            if (elapsedTime >= timeoutMillis) {
                                error("Server check timed out. Instance status is not passed within ${timeoutMinutes} minutes.")
                            }
                        }
                    }
                    //--------------------------------Ansible--------------------------------------------------
                    withCredentials([sshUserPrivateKey(credentialsId: "Ansible_ssh_key", 
                    keyFileVariable: 'KEY_PATH', usernameVariable: 'REMOTE_USER')]) {
                        script{
                            sh "python3 ${WORKSPACE}/ansible/inventory.py"
                            sh "cat ${WORKSPACE}/inventory.ini"
                            
                            sh 'ansible env -m ping -u ${REMOTE_USER} '+
                            '-i ${WORKSPACE}/inventory.ini --private-key=${KEY_PATH}'

                             sh 'ansible-playbook -i ${WORKSPACE}/inventory.ini'+
                            ' ${WORKSPACE}/ansible/playbook.yml'+
                            ' --user=${REMOTE_USER} --key-file=${KEY_PATH}'
                            
                        } 
                    }   
                }
            }
        }
        // ---Work code for create AMI---
        
        stage('Create AMI') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        def amiName = "test_ami_0.1"
                        def region = "eu-central-1"

                        //def amiIds = null
                        def passed = false
                        def timeoutMinutes = 10
                        def startTime = System.currentTimeMillis()

                        def instanceId = sh(script: "aws ec2 describe-instances --region ${region} --filters Name=tag:Name,Values=my-instance-name --query 'Reservations[0].Instances[0].InstanceId' --output text", returnStdout: true).trim()

                        def amiId = sh(script: "aws ec2 create-image --instance-id ${env.instance_id} --name \"${amiName}\" --region ${region} --output text", returnStdout: true).trim()

                        while (!passed) {
                            def output = sh(script: "aws ec2 describe-images --image-ids ${amiId} --region ${region}", returnStdout: true).trim()
                            def json = readJSON(text: output)

                            def state = json.Images[0].State

                            echo "AMI State: ${state}"

                            if (state == 'available') {
                                echo "AMI creation is complete. Proceeding with the pipeline..."
                                passed = true
                            } else {
                                echo "AMI is still being created. Waiting for 30 seconds..."
                                sleep 30
                            }

                            def elapsedTime = System.currentTimeMillis() - startTime
                            def timeoutMillis = timeoutMinutes * 60 * 1000

                            if (elapsedTime >= timeoutMillis) {
                                error("AMI creation timed out. AMI is not available within ${timeoutMinutes} minutes.")
                            }
                        }

                        // Store the new AMI ID for later use
                        env.NEW_AMI_ID = amiId
                        echo "New AMI ID: ${env.NEW_AMI_ID}, AMI created successfully"
                    }
                }
            }
        }
        
        

        
        stage("Create_ASG_&_ELB"){
            steps{
                dir("${WORKSPACE}/test_elb") {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'MainAcademy_AWS_key',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                        sh 'terraform init'
                        sh 'terraform plan'
                        sh "terraform apply -auto-approve -var ami_image_id=${env.NEW_AMI_ID}"
                        
                        //sh "terraform apply -auto-approve"
                        echo 'ok'
                    }
                }
            }
        }
        
        
    }
}

