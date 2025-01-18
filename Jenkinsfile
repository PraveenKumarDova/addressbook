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
            when{
                expression{
                    params.executeTests==true
                }
            }
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
            input{
                message "Select the version to deploy"
                OK "Version selected"
                parameters{
                    choice(name:'NEWAPP',choices:['1.2','2.1','3.1'])
                }
            }
            steps {
                echo "package the code ${params.APPVERSION}"
                sh "mvn package" 
            }

        }
    }
}
