pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any
    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/snandi-altir/terraform-jenkins-param.git'
            }               
            }

        stage('Plan') {
            steps {
                sh 'pwd;ls -l; terraform init'
                sh "pwd;ls -l; terraform plan -out tfplan -var environment=${ENVIRONMENT} -var owner=${OWNER} -var amid=${AMIID} -var instance_size=${INSTANCE_SIZE} -var acl_type=${ACL_TYPE} -var bucketname=${BUCKETNAME}"
                sh 'terraform show  -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                sh "terraform apply -input=false tfplan"
            }
        }
    }

  }