pipeline {
    agent none
    tools{
        maven "mymaven"
    }
    parameters{
        string(name: 'Env', defaultValue: 'Test', description: 'Envt to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'decide to run tc')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'])
    }
    stages {
        stage('compile') {
            agent any 
            steps {
                echo "compile the code in ${params.Env}"
                sh "mvn compile" 
            }
        }    
        stage('test') {
            agent any 
            steps {
                echo "test the code"
                sh "mvn test" 
            }
            post{
               always{
                 junit 'target/surefire-reports/*.xml'
                }
            }       
        }
        
        stage('package') {
            agent any          
            // agent {label'linux_slave1'}
            steps {
                echo "package the code ${params.APPVERSION}"
                sh "mvn package" 
            }

        }
    }
}
