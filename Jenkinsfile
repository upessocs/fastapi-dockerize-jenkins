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
                git url: 'https://github.com/upessocs/devops-test-automation-jenkinsfile.git',
                branch: 'main'
            }
        }
        
        stage('Verify Files') {
            steps {
                sh '''
                    echo "Checking project files..."
                    ls -la
                    pwd
                    echo "\n=== main.py ==="
                    cat main.py
                    echo "\n=== Dockerfile ==="
                    cat Dockerfile
                    echo "\n=== requirements.txt ==="
                    cat requirements.txt
                '''
            }
        }
        
        stage('Build & Push Docker Image') {
            steps {
                script {
                    def fullTag = "${env.DOCKER_IMAGE}:${params.IMAGE_TAG}-${env.BUILD_NUMBER}"
                    sh """
                        echo "Logging into Docker Hub..."
                        
                        echo ${DOCKERHUB_CREDENTIALS} | docker login -u "prateekrajgautam" --password-stdin
                        echo "Building Docker image with tag: ${fullTag}"
                        docker build -t ${fullTag} .
                        echo "Pushing image to Docker Hub..."
                        docker push ${fullTag}
                    """
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