pipeline {
    agent {
        label 'docker-slave'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Siddeshg672/hello_world_public_war.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package'
                sh 'find . -name "*.war" || echo "No WAR file found!"'
            }
        }

        stage('Run Tomcat Container') {
            steps {
                sh '''
                docker stop tomcat-container || true
                docker rm tomcat-container || true
                docker run -d --name tomcat-container -p 8080:8080 tomcat:9.0.100-jdk17
                '''
            }
        }

        stage('Deploy WAR to Tomcat') {
            steps {
                sh '''
                sleep 10
                WAR_FILE=$(find . -name "*.war")
                
                if [ -z "$WAR_FILE" ]; then
                    echo "ERROR: WAR file not found!"
                    exit 1
                fi

                docker cp $WAR_FILE tomcat-container:/usr/local/tomcat/webapps/app.war
                '''
            }
        }
    }
}
