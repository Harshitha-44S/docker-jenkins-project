pipeline {
    agent any

    environment {
        IMAGE_NAME     = 'jenkins-docker-app'
        CONTAINER_NAME = 'jenkins-docker-app'
        HOST_PORT      = '8081'
    }

    stages {
        stage('Pull code from GitHub') {
            steps {
                // Jenkins job is configured as "Pipeline script from SCM",
                // so this checks out the repo automatically.
                checkout scm
            }
        }

        stage('Build Docker image') {
            steps {
                bat 'docker build -t %IMAGE_NAME%:%BUILD_NUMBER% -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Run container') {
            steps {
                // Remove old container if present (ignore error if none exists)
                bat 'docker rm -f %CONTAINER_NAME% || exit 0'
                bat 'docker run -d --name %CONTAINER_NAME% -p %HOST_PORT%:80 %IMAGE_NAME%:latest'
            }
        }

        stage('Verify') {
            steps {
                bat 'docker ps --filter "name=%CONTAINER_NAME%"'
            }
        }
    }

    post {
        success { echo "Deployed. Open http://localhost:${HOST_PORT}" }
        failure { echo 'Pipeline failed - check the console output above.' }
    }
}
