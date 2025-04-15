pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        DOCKER_IMAGE = 'prateekrajgautam/devops-test-automation'
    }

    parameters {
        string(
            name: 'IMAGE_TAG', 
            defaultValue: 'v0.1', 
            description: 'Docker image tag version'
        )
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[url: 'https://github.com/upessocs/fastapi-dockerize-jenkins.git']]
                ])
            }
        }
        
        stage('Build & Push Docker Image') {
            steps {
                script {
                    def fullTag = "${env.DOCKER_IMAGE}:${params.IMAGE_TAG}-${env.BUILD_NUMBER}"
                    
                    // Secure way to handle credentials
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh """
                            docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
                            docker build -t ${fullTag} .
                            docker push ${fullTag}
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
            cleanWs()
        }
        success {
            echo "Docker image successfully built and pushed!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}