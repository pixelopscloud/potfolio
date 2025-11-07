pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "pixelopscloud/todo-app:latest"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }
        stage('Deploy Container') {
            steps {
                sh '''
                    docker stop todo-app || true
                    docker rm todo-app || true
                    docker image prune -f
                    docker run -d -p 3000:3000 --name todo-app ${DOCKER_IMAGE}
                '''
            }
        }
    }
}
