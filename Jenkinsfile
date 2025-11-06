pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-credentials',
                    url: 'https://github.com/pixelopscloud/GitOps-.git',
                    branch: 'main'
            }
        }
        
        stage('Show Files') {
            steps {
                sh 'ls -la'
                sh 'cat index.html'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t pixelopscloud/abd-app:${BUILD_NUMBER} ."
                    sh "docker tag pixelopscloud/abd-app:${BUILD_NUMBER} pixelopscloud/abd-app:latest"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh "docker push pixelopscloud/abd-app:${BUILD_NUMBER}"
                        sh "docker push pixelopscloud/abd-app:latest"
                    }
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
        }
    }
}
