pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "pixelopscloud"
        IMAGE_NAME = "taskmanager-frontend"
        API_URL = "http://backend-service:5000/api"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build \
                --build-arg REACT_APP_API_URL=${API_URL} \
                -t ${DOCKERHUB_USER}/${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest"
            }
        }
    }
}

