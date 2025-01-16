pipeline {
    agent none
    tools{
        mvn "mymaven"
    }
    stages {
        stage('compile') {
            agent any 
            steps {
                echo "compile the code"
                sh "mvn compile" 
            }
        }    
        stage('test') {
            agent any 
            steps {
                echo "test the code"
                sh "mvn test" 
            }   
        }
        stage('package') {
            agent {label'jenkins_slave1'}
            steps {
                echo "package the code"
                sh "mvn package" 
            }

        }
    }
}
