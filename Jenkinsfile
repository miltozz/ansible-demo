pipeline {
    agent any
    environment {
        ANSIBLE_SERVER = "13.37.212.165"
    }
 
    stages {
        stage("init") {
            steps {
                script {
                    echo "Copy files from Jenkins pipeline repo to ansible-server"

                    sshagent(['ansible-server']){
                        // ${ANSIBLE_SERVER}:/home/ubuntu without [user]ubuntu will give jenkins@${ANSIBLE_SERVER}:/home/ubuntu                        
                        sh "scp  -v -o StrictHostKeyChecking=no ansible/* ubuntu@${ANSIBLE_SERVER}:/home/ubuntu"
                    }

                    echo "copying ssh keys from Jenkins creds store to ansible-server for ec2 instances"
                    // note: single quotes prevent Groovy interpolation
                    //You should use a single quote (') instead of a double quote (") whenever you can. 
                    //https://plugins.jenkins.io/credentials-binding/
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2-nodes-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                        sh 'scp $keyfile ubuntu@$ANSIBLE_SERVER:/home/ubuntu/ssh-key.pem'
                    }

                }
            }
        }
    }   
}
