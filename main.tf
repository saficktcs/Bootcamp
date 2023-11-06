pipeline {
    agent any
    
    environment {
        SSH_CREDENTIALS = credentials('APKAVDYSQ72RJ4WSIAOU') 
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'f322580e-fb5f-44a3-8f87-14ba94faf33e', url: 'ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/Bootcamp23']])
            }
        }
    
    
        stage('Creating Terraform Config') {
            steps {
                sh 'python3 sandy.py'
            }
        }
        
        stage('Initializing Terraform') {
            steps {
                sh 'terraform init -migrate-state'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Extract Terraform Output') {
            steps {
                script {
                    def instanceIP = sh(script: "terraform output instance_ip", returnStdout: true).trim()
                    def instanceName = sh(script: "terraform output instance_name", returnStdout: true).trim()

                    echo "Instance IP: $instanceIP"
                    echo "Instance Name: $instanceName"

                    // Verwende die Variablen für spätere Schritte in der Pipeline
                }
            }
        }
    }
}
