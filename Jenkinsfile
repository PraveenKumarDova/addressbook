pipeline {
    agent none
    tools{
        maven "mymaven"
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
        post{
            always{
                junit 'target/surefire-reports/*.xml'
            }
        }
        stage('package') {
            agent any          
            // agent {label'linux_slave1'}
            steps {
                echo "package the code"
                sh "mvn package" 
            }

        }
    }
}
