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
                        sh "scp  -v -o StrictHostKeyChecking=no ansible/* ubuntu@13.37.212.165:/home/ubuntu"
                    }
                }
            }
        }
    }   
}
