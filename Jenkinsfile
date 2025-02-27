pipeline {
    agent none
    tools{
        maven "mymaven"
    }
    environment {
        DEV_SERVER_IP='ec2-user@172.31.46.242'
        DEPLOY_SERVER_IP='ec2-user@172.31.33.69'
        IMAGE_NAME='praveenkumardova/addressbook'
    }
    parameters {
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
            agent {label 'linux_slave1'}
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
            // input{
            //     message "Select the version to deploy"
            //     ok "Version selected"
            //     parameters{
            //         choice(name:'NEWAPP',choices:['1.2','2.1','3.1'])
            //     }
            // }
            steps {
                script{
                sshagent(['jenkins-slave2']){
                    withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    echo "package the code ${params.APPVERSION}"
                    sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER_IP}:/home/ec2-user/" 
                    sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER_IP} 'bash ~/server-script.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"
                    sh "ssh ${DEV_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                    sh "ssh ${DEV_SERVER_IP} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                    }
                    }
                }
            }

        }
        
        stage('Infrastructure provisioning'){
            agent any
            steps{
                script{
                    dir('terraform'){
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                        EC2_PUBLIC_IP= sh(
                            script: "terraform output ec2-ip",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }


        stage('deploy') {
            agent any          
            // agent {label'linux_slave1'}
            // input{
            //     message "Select the version to deploy"
            //     ok "Version selected"
            //     parameters{
            //         choice(name:'NEWAPP',choices:['1.2','2.1','3.1'])
            //     }
            // }
            steps {
                script{
                sshagent(['jenkins-slave2']){
                    echo "waiting for ec2 instance to initialize"
                    sleep(time:90,unit: "SECONDS")
                    echo ${EC2_PUBLIC_IP}
                    withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    echo "package the code ${params.APPVERSION}"
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} sudo yum install docker -y"
                    sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo systemctl start docker"
                    sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                    sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo docker run -it -d -p 8080:8080 ${IMAGE_NAME}:${BUILD_NUMBER}"
                    }
                    }
                }
            }

        }
    }
}
