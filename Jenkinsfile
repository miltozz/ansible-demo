pipeline {
    agent any
    stages {
        stage("init") {
            steps {
                script {
                    echo "Copy files to ansible-server"

                    sshagent(['ansible-server']){
                        sh "ls -lah"
                        sh "pwd"
                        sh "whoami"
                        sh "ssh -vvv -o StrictHostKeyChecking=no -T ubuntu@35.180.74.15"
                        //sh "scp  -v -o StrictHostKeyChecking=no ansible/* ubuntu@35.180.74.15:/home/ubuntu"
                    }
                }
            }
        }
    }   
}
