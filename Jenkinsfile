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
                git branch: 'ClamAV-antimailware', credentialsId: 'Access_to_Git', url: 'https://github.com/Gnomina/Project_MainAcademy.git'
                echo "Клонированный репозиторий находится в папке: ${WORKSPACE}"
            }
        }

        stage('Get Terraform Variable') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        def tfStateFile = sh(script: "aws s3 cp s3://mainacademy-project-terraform-back/dev/backend/terraform.tfstate -", returnStdout: true).trim()
                        def tfStateJson = readJSON(text: tfStateFile)
                        def ip = tfStateJson.outputs.instance_public_ip.value
                        def id = tfStateJson.outputs.instance_id.value
                        echo "IP = ${ip}"
                        echo "ID = ${id}"
                        env.my_ip = ip //create environment variable - env.my_ip
                        env.instance_id = id //create environment variable - env.instance_id
                    }                      
                }       
            }
            
        }

        stage('Write Inventory') {
            steps {
                script {
                    def inventoryFile = "${WORKSPACE}/ansible/inventory.ini"
                    sh "sed -i 's/REPLACE_WITH_IP/${env.my_ip}/g' ${inventoryFile}"
                }
            }
        }

        stage('Status check') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        def passed = false
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
                        }
                    }
                }
            }
        }
    }
} 

//InstanceStatus: initializing
//SystemStatus: initializing
//InstanceStatus: passed
//SystemStatus: passed


/*
if (instanceStatus == 'initializing') {
                            echo 'Instance is initializing. Waiting for 10 seconds...'
                            sleep(time: 10, unit: 'SECONDS')
                        } else if (instanceStatus == 'passed'){
                            echo 'Instance status is passed. Proceeding with pipeline...'
                        }
*/



/*
        stage('Run Ansible playbook') {
             steps {
                withCredentials([sshUserPrivateKey(credentialsId: "12345", 
                keyFileVariable: 'KEY_PATH', usernameVariable: 'REMOTE_USER')]) {
                
                    sh "ssh-keyscan 3.73.91.12 >> ~/.ssh/known_hosts"

                    sh 'ansible all -m ping -u ${REMOTE_USER} '+
                       '-i ${WORKSPACE}/ansible/inventory.ini --private-key=${KEY_PATH}'

                    sh 'ansible-playbook -i ${WORKSPACE}/ansible/inventory.ini'+
                       ' ${WORKSPACE}/ansible/playbook.yml'+
                       ' --user=${REMOTE_USER} --key-file=${KEY_PATH}'
                }
            }
        }
    }
}
*/