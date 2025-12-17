pipeline {
    agent any

    environment {
        GITHUB_CREDENTIALS = 'github-credentials'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        FRONTEND_IMAGE = 'pixelopscloud/taskmanager-frontend:latest'
        BACKEND_IMAGE = 'pixelopscloud/taskmanager-backend:latest'
        FRONTEND_PATH = 'frontend'
        BACKEND_PATH = 'backend'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git(
                    url: 'https://github.com/pixelopscloud/potfolio.git',
                    branch: 'main',
                    credentialsId: "${GITHUB_CREDENTIALS}"
                )
            }
        }

        stage('Build Frontend Image') {
            steps {
                script {
                    sh "docker build -f ${FRONTEND_PATH}/Dockerfile --build-arg REACT_APP_API_URL=http://backend-service:5000/api -t ${FRONTEND_IMAGE} ${FRONTEND_PATH}"
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                script {
                    sh "docker build -f ${BACKEND_PATH}/Dockerfile -t ${BACKEND_IMAGE} ${BACKEND_PATH}"
                }
            }
        }

        stage('Docker Login & Push Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    sh "docker push ${FRONTEND_IMAGE}"
                    sh "docker push ${BACKEND_IMAGE}"
                }
            }
        }
    }

    post {
        success {
            echo 'Frontend & Backend images built and pushed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs!'
        }
    }
}

