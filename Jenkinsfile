pipeline {
  agent any

  environment {
    DOCKERHUB_USER = "pixelopscloud"
    FRONTEND_IMAGE = "${DOCKERHUB_USER}/frontend-app:${BUILD_NUMBER}"
    BACKEND_IMAGE  = "${DOCKERHUB_USER}/backend-app:${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Docker Login') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'DOCKERHUB-ID',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
        }
      }
    }

    stage('Build Frontend') {
      steps {
        dir('frontend') {
          sh 'docker build -t $FRONTEND_IMAGE .'
        }
      }
    }

    stage('Build Backend') {
      steps {
        dir('backend') {
          sh 'docker build -t $BACKEND_IMAGE .'
        }
      }
    }

    stage('Push Images') {
      steps {
        sh '''
          docker push $FRONTEND_IMAGE
          docker push $BACKEND_IMAGE
        '''
      }
    }
  }
}

