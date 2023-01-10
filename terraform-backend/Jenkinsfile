pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
            checkout scmGit(branches: [[name: '*/main']], extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'terraform-backend']], userRemoteConfigs: [[url: 'https://github.com/shitalkumar58627/terraform-aws-.git']])

          }
        }
        stage("set env variabl"){
            steps{
                sh 'export AWS_PROFILE=ilab'
            }
        }

        stage ("terraform init") {
            steps {
                sh ('terraform init') 
            }
        }
        
       stage('Terraform Apply'){
            steps{
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "ilab-aws",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                sh 'terraform apply --auto-approve'
                }
            }
        }
        
    }
}
