pipeline {
    agent any
    
    environment {
        // Docker Hub Credentials
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_HUB_USERNAME = 'pixelopscloud'
        
        // Docker Images
        FRONTEND_IMAGE = "${DOCKER_HUB_USERNAME}/frontend-app"
        BACKEND_IMAGE = "${DOCKER_HUB_USERNAME}/backend-app"
        
        // GitHub Repository
        GIT_REPO = 'https://github.com/pixelopscloud/GitOps-.git'
    }
    
    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
                echo '✅ Workspace cleaned successfully'
            }
        }
        
        stage('Checkout Code') {
            steps {
                script {
                    echo '📥 Cloning repository from GitHub...'
                    git branch: 'main', 
                        url: "${GIT_REPO}",
                        credentialsId: 'github-credentials'
                }
            }
        }
        
        stage('Stop Running Containers') {
            steps {
                script {
                    echo '🛑 Stopping existing containers...'
                    dir('Docker-Compose-Projects') {
                        sh '''
                            docker compose down || true
                            docker container prune -f || true
                        '''
                    }
                }
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    echo '🔨 Building Docker images...'
                    dir('Docker-Compose-Projects') {
                        sh '''
                            docker compose build --no-cache
                        '''
                    }
                }
            }
        }
        
        stage('Tag Images for Docker Hub') {
            steps {
                script {
                    echo '🏷️ Tagging images for Docker Hub...'
                    sh """
                        docker tag fronted-image:latest ${FRONTEND_IMAGE}:latest
                        docker tag fronted-image:latest ${FRONTEND_IMAGE}:v${BUILD_NUMBER}
                        
                        docker tag backend-image:latest ${BACKEND_IMAGE}:latest
                        docker tag backend-image:latest ${BACKEND_IMAGE}:v${BUILD_NUMBER}
                        
                        echo "Images tagged successfully!"
                        docker images | grep ${DOCKER_HUB_USERNAME}
                    """
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo '📤 Pushing images to Docker Hub...'
                    sh """
                        echo \$DOCKER_HUB_CREDENTIALS_PSW | docker login -u \$DOCKER_HUB_CREDENTIALS_USR --password-stdin
                        
                        echo "Pushing Frontend images..."
                        docker push ${FRONTEND_IMAGE}:latest
                        docker push ${FRONTEND_IMAGE}:v${BUILD_NUMBER}
                        
                        echo "Pushing Backend images..."
                        docker push ${BACKEND_IMAGE}:latest
                        docker push ${BACKEND_IMAGE}:v${BUILD_NUMBER}
                        
                        docker logout
                        echo "✅ All images pushed successfully!"
                    """
                }
            }
        }
        
        stage('Deploy Application') {
            steps {
                script {
                    echo '🚀 Deploying application...'
                    dir('Docker-Compose-Projects') {
                        sh '''
                            docker compose up -d
                            echo "Waiting for containers to start..."
                            sleep 15
                            docker compose ps
                        '''
                    }
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    echo '🏥 Performing health check...'
                    sh '''
                        echo "Waiting for services to be ready..."
                        timeout=120
                        interval=5
                        elapsed=0

                        echo "Checking Frontend (Port 3000)..."
                        while [ $elapsed -lt $timeout ]; do
                          if curl -fsS --max-time 5 http://127.0.0.1:3000 >/dev/null 2>&1; then
                            echo "✅ Frontend is up and responding!"
                            break
                          fi
                          echo "Waiting for frontend... ${elapsed}s"
                          sleep $interval
                          elapsed=$((elapsed+interval))
                        done

                        if [ $elapsed -ge $timeout ]; then
                          echo "❌ Frontend failed to respond within ${timeout}s"
                          exit 1
                        fi

                        echo "Checking Backend (Port 3500)..."
                        elapsed=0
                        while [ $elapsed -lt $timeout ]; do
                          if curl -fsS --max-time 5 http://127.0.0.1:3500 >/dev/null 2>&1; then
                            echo "✅ Backend is up and responding!"
                            break
                          fi
                          echo "Waiting for backend... ${elapsed}s"
                          sleep $interval
                          elapsed=$((elapsed+interval))
                        done

                        if [ $elapsed -ge $timeout ]; then
                          echo "❌ Backend failed to respond within ${timeout}s"
                          exit 1
                        fi

                        echo "✅ All services are healthy!"
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo '🎉 =========================================='
            echo '    Pipeline executed successfully!'
            echo '=========================================='
            echo ''
            echo '✅ Application is running:'
            echo '   Frontend: http://localhost:3000'
            echo '   Backend:  http://localhost:3500'
            echo ''
            echo '✅ Images pushed to Docker Hub:'
            echo "   ${FRONTEND_IMAGE}:latest"
            echo "   ${FRONTEND_IMAGE}:v${BUILD_NUMBER}"
            echo "   ${BACKEND_IMAGE}:latest"
            echo "   ${BACKEND_IMAGE}:v${BUILD_NUMBER}"
            echo '=========================================='
        }
        failure {
            echo '❌ Pipeline failed!'
            echo 'Rolling back...'
            sh '''
                cd Docker-Compose-Projects
                docker compose down || true
            '''
        }
        always {
            echo '🧹 Cleaning up unused Docker images...'
            sh '''
                docker image prune -f || true
            '''
        }
    }
}

