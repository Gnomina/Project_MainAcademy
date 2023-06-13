stage("AWS Cred"){
    steps{
        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'MainAcademy_AWS_key',
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                sh "aws ec2 describe-instances --region eu-central-1"
                sh "aws ec2 describe-security-groups --region eu-central-1 --output table" 
                sh "aws ec2 describe-vpcs --region eu-central-1 --output table"       
        }
    }
}