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
                git url: 'https://github.com/upessocs/fastapi-dockerize-jenkins.git',
                branch: 'main'
            }
        }
        
       
        
        stage('Build & Push Docker Image') {
            steps {
                script {
                    def fullTag = "${env.DOCKER_IMAGE}:${params.IMAGE_TAG}-${env.BUILD_NUMBER}"
                    echo "Full Docker image tag: ${fullTag}"
                    echo "Building Docker image with tag: ${fullTag}"
                    echo "Using Docker Hub credentials: ${DOCKERHUB_CREDENTIALS}"
                    echo "Docker Hub username: prateekrajgautam"
                    echo "Docker Hub password: ${DOCKERHUB_CREDENTIALS_PSW}"
                    echo "Docker Hub email: ${DOCKERHUB_CREDENTIALS_EMAIL}"
                    echo "Docker Hub server: ${DOCKERHUB_CREDENTIALS_SERVER}"
                    echo "Docker Hub ID: ${DOCKERHUB_CREDENTIALS_ID}"
                    echo "Docker Hub description: ${DOCKERHUB_CREDENTIALS_DESCRIPTION}"
                    echo "Docker Hub scope: ${DOCKERHUB_CREDENTIALS_SCOPE}"
                    echo "Docker Hub secret: ${DOCKERHUB_CREDENTIALS_SECRET}"
                    sh '''
                        echo "Logging into Docker Hub..."
                        
                        echo ${DOCKERHUB_CREDENTIALS} | docker login -u "prateekrajgautam" --password-stdin
                        echo "Building Docker image with tag: ${fullTag}"
                        docker build -t ${fullTag} .
                        echo "Pushing image to Docker Hub..."
                        docker push ${fullTag}
                    '''
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