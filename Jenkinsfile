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
                script{
                    def branchName = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
                    def repositoryName = sh(returnStdout: true, script: 'git remote show origin -n | grep "Fetch URL:" | awk -F/ \'{print $NF}\' | sed -e "s/.git$//"').trim().toLowerCase()
                    env.repository_name = repositoryName     
                    env.work_branch = branchName
                    echo "PATH to clone repo: ${WORKSPACE}"
                    echo "Repository name: ${env.repository_name}"
                    echo "Branch name: ${env.work_branch}"
                }
            }
        }
//--------------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------Bucket url---------------------------------------------------------------------------------------
        stage("Get Bucket Info") {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'MainAcademy_AWS_key',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                    script {
                        def targetBucketName = ''
                        def region = ''
                        def bucketUrl = ''

                        // Определение требуемого имени ведра
                        if (env.work_branch.toLowerCase().contains("dev")) {
                            targetBucketName = "dev"
                        } else if (env.work_branch.toLowerCase().contains("prod")) {
                            targetBucketName = "prod"
                        }

                        // Получение списка ведер
                        def listBucketsOutput = sh(returnStdout: true, script: 'aws s3api list-buckets')
                        def buckets = readJSON(text: listBucketsOutput)

                        // Поиск ведра с требуемым именем
                        for (bucket in buckets.Buckets) {
                            def name = bucket.Name.toLowerCase()
                            if (name.contains(targetBucketName)) {
                                targetBucketName = bucket.Name
                                break
                            }
                        }

                        // Получение региона размещения ведра
                        if (targetBucketName) {
                            def getBucketLocationOutput = sh(returnStdout: true, script: "aws s3api get-bucket-location --bucket ${targetBucketName}")
                            def location = readJSON(text: getBucketLocationOutput)
                            region = location.LocationConstraint
                        }

                        // Формирование URL ведра
                        if (targetBucketName && region) {
                           bucketUrl = "${targetBucketName}.s3.${region}.amazonaws.com"
                           //bucketUrl = "${targetBucketName}.s3.${region}.amazonaws.com"
                        }
                        def distributionId = sh(returnStdout: true, script: 'aws cloudfront list-distributions --query "DistributionList.Items[].Id" --output text').trim()

                        // Вывод результатов
                        echo "Bucket Name: ${targetBucketName}"
                        echo "Region: ${region}"
                        echo "Bucket URL: ${bucketUrl}"
                        echo "Distribution ID: ${distributionId}"

                        // Запись значений в переменные
                        env.NameBucket = targetBucketName
                        env.region = region
                        env.bucket_url = bucketUrl

                        sh "aws s3 sync ${WORKSPACE} s3://${targetBucketName}/ --delete"

                        sh "aws cloudfront create-invalidation --distribution-id ${distributionId} --paths '/*'"
                        //aws cloudfront get-invalidation --distribution-id <distribution-id> --id <invalidation-id> можно сделать проверку статуса invalodate, но пока что лень.

                            
                    }
                }
            }
        }
    }
}

