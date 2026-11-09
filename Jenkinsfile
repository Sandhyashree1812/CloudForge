pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Backend Image') {
            steps {
                sh 'docker build -t cloudforge-backend:ci ./backend'
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh 'docker build -t cloudforge-frontend:ci ./frontend'
            }
        }

        stage('Build Admin Image') {
            steps {
                sh 'docker build -t cloudforge-admin:ci ./admin'
            }
        }
    }

    post {
        success {
            echo 'All CloudForge Docker images built successfully.'
        }
        failure {
            echo 'CloudForge CI pipeline failed. Review the stage logs.'
        }
    }
}
