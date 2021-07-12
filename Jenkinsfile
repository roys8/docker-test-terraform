pipeline {
    agent any

    stages {
        stage('Build-Dev') {
            steps {
                echo 'Hello World'
                sh '''
                docker build . -t newimage
                '''
            }
        }
		stage('Push') {
		    steps {
			    withDockerRegistry([credentialsId: "ecr:us-east-1:ecr-user", url: "335010663577.dkr.ecr.us-east-1.amazonaws.com/test-ecr-repo:dev"]) {
				    sh '''
				        docker tag newimage:latest 335010663577.dkr.ecr.us-east-1.amazonaws.com/test-ecr-repo:dev
						docker push 335010663577.dkr.ecr.us-east-1.amazonaws.com/test-ecr-repo:dev
				    '''
				}
			}
		}
        stage('Test'){
            agent {
                docker {
                    image 'newimage:latest'
                    args '-i --entrypoint=""'
                }
            }
            steps {
                sh '''
                python3 --version
                terraform --version
                python3 app.py
                '''
                script {
                    input(message: "Deploy to prod?")
                }
            }
        }
        stage('Production'){
            agent {
                docker {
                    image 'newimage:latest'
                    args '-i --entrypoint=""'
                }
            }
            steps {
                sh '''
                aws sts get-caller-identity
                terraform init
                terraform plan
                python3 app.py
                '''
            }
        }
    }
}