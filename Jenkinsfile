pipeline {
    agent any

    stages {
        stage('Unit Test') {
            agent {
                label 'ubuntu-vm'
            }
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
                sh 'trivy image --ignorefile .trivyignore --severity HIGH,CRITICAL --exit-code 1 suryaraj/nodejs-app:${BUILD_NUMBER}'
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

        stage('Deploy to Dev') {
            steps {
                sh '''
                    if docker container inspect java-maven-app-dev >/dev/null 2>&1; then
                        docker rm --force java-maven-app-dev
                    fi
                    docker run --detach \
                        --name java-maven-app-dev \
                        --restart unless-stopped \
                        --publish 8085:8080 \
                        suryaraj/nodejs-app:${BUILD_NUMBER}
                '''
            }
        }

        stage('Approve Production Deployment') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: "Deploy build #${env.BUILD_NUMBER} to production?", ok: 'Deploy to production'
                }
            }
        }

        stage('Deploy to Prod') {
            steps {
                sh '''
                    if docker container inspect java-maven-app-prod >/dev/null 2>&1; then
                        docker rm --force java-maven-app-prod
                    fi
                    docker run --detach \
                        --name java-maven-app-prod \
                        --restart unless-stopped \
                        --publish 8086:8080 \
                        suryaraj/nodejs-app:${BUILD_NUMBER}
                '''
            }
        }
    }

    post {
        success {
            mail bcc: '', body: """Hi Team,

Build #$BUILD_NUMBER is successful, please go through the url

$BUILD_URL

and verify the details.

Regards,
DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD SUCCESS NOTIFICATION', to: 'devopsuryaraj@gmail.com'
        }
        failure {
            mail bcc: '', body: """Hi Team,
            
Build #$BUILD_NUMBER is unsuccessful, please go through the url

$BUILD_URL

and verify the details.

Regards,
DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD FAILED NOTIFICATION', to: 'devopsuryaraj@gmail.com'
        }
    }
}
