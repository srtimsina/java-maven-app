pipeline {
    agent any

    stages {
        stage('Unit Test') {
            steps {
                sh 'mvn --batch-mode --no-transfer-progress test'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn --batch-mode --no-transfer-progress clean package -DskipTests'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'target/java-maven-app.war', fingerprint: true
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t suryaraj/nodejs-app:${BUILD_NUMBER} .'
            }
        }

        stage('Scan Docker Image') {
            steps {
                sh 'trivy image --severity HIGH,CRITICAL --exit-code 1 suryaraj/nodejs-app:${BUILD_NUMBER}'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKERHUB_USERNAME',
                    passwordVariable: 'DOCKERHUB_PASSWORD'
                )]) {
                    script {
                        try {
                            sh '''
                                set +x
                                printf '%s' "$DOCKERHUB_PASSWORD" | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
                            '''
                            sh 'docker push suryaraj/nodejs-app:${BUILD_NUMBER}'
                        } finally {
                            sh 'docker logout'
                        }
                    }
                }
            }
        }
    }
}
