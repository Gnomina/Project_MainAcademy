pipeline {
    //agent any
    
    agent {
        label 'Master'
    }
    
    options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timestamps()
    timeout(time: 1, unit: 'HOURS')
    }

    stages {

        stage('CLEAN_WORKSPACE') {
            steps {
               cleanWs()
            }
        }

        stage('Clone') {
            steps {
                git branch: 'ansible-dynamic-inventory', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                echo "PATH to clone repo: ${WORKSPACE}"
            }
        }

        stage('inventory') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                                               
                        sh "python3 ${WORKSPACE}/invent.py"
                        sh "cat ${WORKSPACE}/inventory.ini"

                        
                    }                      
                }       
            }
        }
/*
        stage('Run Ansible playbook') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: "12345", 
                keyFileVariable: 'KEY_PATH', usernameVariable: 'REMOTE_USER')]) {
                    sh 'ansible-playbook -i "$(ansible-inventory -i ${WORKSPACE}/ansible/aws_ec2.yaml --list)" ${WORKSPACE}/ansible/playbook.yml --user=${REMOTE_USER} --key-file=${KEY_PATH}'

                    sh 'ansible-playbook -i ${WORKSPACE}/ansible/inventory.ini'+
                       ' ${WORKSPACE}/ansible/playbook.yml'+
                       ' --user=${REMOTE_USER} --key-file=${KEY_PATH}'
               
                }
            }
        }
*/

        /*
        stage('Write Inventory') {
            steps {
                script {
                    def inventoryFile = "${WORKSPACE}/ansible/inventory.ini"
                    sh "sed -i 's/REPLACE_WITH_IP/${env.my_ip}/g' ${inventoryFile}"
                }
            }
        }
        */  
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
        }
        */
        
        
        
    }
}
        
