pipeline {
    agent any
    // agent {
    //     docker {
    //         image 'docker:latest'
    //         args '-u root:root'
    //     }
    //     // docker {
    //     //     image 'docker:latest'  // Uses a Docker-in-Docker (DinD) container
    //     //     args '-v /var/run/docker.sock:/var/run/docker.sock'  // Shares host Docker socket
    //     // }
    // }
    
    environment {
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
                checkout scm
            }
        }

        stage("dockerinstall"){
            steps {
                script {
                    // Install Docker if not already installed
                    sh '''
                        if ! command -v docker &> /dev/null; then
                            echo "Docker not found, installing..."
                            sudo usermod -aG docker jenkins
                            sudo apt-get update
                            sudo apt-get install -y docker.io
                            sudo systemctl start docker
                            sudo systemctl enable docker
                            sudo docker run hello-world
                            docker --version
                        else
                            echo "Docker is already installed."
                        fi
                    '''
                }
            }   
        }
        
        stage('Build & Push Docker Image') {
            steps {
                script {
                    // Assuming 'dockerhub-creds' is a Docker Hub password/PAT (Secret text)
                    withCredentials([string(
                        credentialsId: 'dockerhub-creds',
                        variable: 'DOCKER_PASS'
                    )]) {
                        def fullTag = "${env.DOCKER_IMAGE}:${params.IMAGE_TAG}-${env.BUILD_NUMBER}"
                        sh '''
                            echo ${DOCKER_PASS} | docker login -u prateekrajgautam --password-stdin 
                            docker build -t ${fullTag} .
                            docker push ${fullTag}
                        '''
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                try {
                    sh 'docker logout'
                } catch (Exception e) {
                    echo "Failed to logout from Docker: ${e.message}"
                }
                cleanWs()
            }
        }
        success {
            echo "Docker image successfully built and pushed!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}