pipeline {
    agent any
    stages {
        stage('compile') {
            steps {
                echo "compile the code"
                sh "mvn compile" 
            }
        }    
        stage('test') {
            steps {
                echo "test the code"
                sh "mvn test" 
            }   
        }
        stage('package') {
            steps {
                echo "package the code"
                sh "mvn package" 
            }

        }
    }
}
