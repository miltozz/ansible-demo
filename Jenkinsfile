pipeline {
    agent any
    stages {
        stage("init") {
            steps {
                script {
                    echo "Copy files to ansible-server"

                    sshagent(['ansible-server']){
                        sh "scp -o StrictHostKeyChecking=no ansible/* ubuntu@35.180.74.15:/home/ubuntu"
                    }
                }
            }
        }
    }   
}
