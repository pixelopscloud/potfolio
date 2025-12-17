pipeline {
  agent any
  
  environment {
    DOCKERHUB_USER = "pixelopscloud"
    FRONTEND_IMAGE = "${DOCKERHUB_USER}/taskmanager-frontend"
    BACKEND_IMAGE  = "${DOCKERHUB_USER}/taskmanager-backend"
    VERSION = "${BUILD_NUMBER}"
  }
  
  stages {
    stage('Cleanup Workspace') {
      steps {
        cleanWs()
      }
    }
    
    stage('Checkout Code') {
      steps {
        git branch: 'main',
            credentialsId: 'github-credentials',
            url: 'https://github.com/pixelopscloud/potfolio.git'
      }
    }
    
    stage('Build Backend Image') {
      steps {
        script {
          dir('backend') {
            sh """
              docker build -t ${BACKEND_IMAGE}:${VERSION} .
              docker tag ${BACKEND_IMAGE}:${VERSION} ${BACKEND_IMAGE}:latest
            """
          }
        }
      }
    }
    
    stage('Build Frontend Image') {
      steps {
        script {
          dir('frontend') {
            sh """
              docker build -t ${FRONTEND_IMAGE}:${VERSION} .
              docker tag ${FRONTEND_IMAGE}:${VERSION} ${FRONTEND_IMAGE}:latest
            """
          }
        }
      }
    }
    
    stage('Docker Login') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-credentials',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
        }
      }
    }
    
    stage('Push Images to Docker Hub') {
      steps {
        sh """
          docker push ${BACKEND_IMAGE}:${VERSION}
          docker push ${BACKEND_IMAGE}:latest
          docker push ${FRONTEND_IMAGE}:${VERSION}
          docker push ${FRONTEND_IMAGE}:latest
        """
      }
    }
    
    stage('Cleanup Local Images') {
      steps {
        sh """
          docker rmi ${BACKEND_IMAGE}:${VERSION} || true
          docker rmi ${BACKEND_IMAGE}:latest || true
          docker rmi ${FRONTEND_IMAGE}:${VERSION} || true
          docker rmi ${FRONTEND_IMAGE}:latest || true
        """
      }
    }
  }
  
  post {
    always {
      sh 'docker logout'
    }
    success {
      echo '✅ ======================================'
      echo '✅ Pipeline Completed Successfully!'
      echo '✅ ======================================'
      echo "Backend Image: ${BACKEND_IMAGE}:${VERSION}"
      echo "Frontend Image: ${FRONTEND_IMAGE}:${VERSION}"
      echo '✅ Images pushed to Docker Hub'
    }
    failure {
      echo '❌ ======================================'
      echo '❌ Pipeline Failed!'
      echo '❌ Check console output for errors'
      echo '❌ ======================================'
    }
  }
}
