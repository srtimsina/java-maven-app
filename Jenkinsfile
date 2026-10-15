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
    }
}
