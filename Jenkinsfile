pipeline {
    agent any
    environment {
        ANSIBLE_SERVER = "13.36.209.172" 
    }
 
    stages {
        stage("Copy files from Jenkins pipeline repo to ansible-server") {
            steps {
                script {
                    echo "Copy files to ansible-server"

                    //Jenkins ssh agent doesn't work with new BEGIN OPENSSH PRIVATE KEY keys. it needs BEGIN RSA PRIVATE KEY.it needs PEM
                    //generate or convert keys with smth like 'ssh-keygen -m PEM -t rsa -P "" -f afile'
                    //docker-paris is ans-server-key 
                    sshagent(['docker-server-key']){
                        // ${ANSIBLE_SERVER}:/home/ubuntu without [user]ubuntu will give jenkins@${ANSIBLE_SERVER}:/home/ubuntu                        
                        sh "scp -o StrictHostKeyChecking=no ansible/* ubuntu@${ANSIBLE_SERVER}:/home/ubuntu/testdir"
                    

                        echo "copying ssh keys from Jenkins creds store to ansible-server for ec2 instances"
                        // note: single quotes prevent Groovy interpolation. double quoutes give unsafe warnings
                        //You should use a single quote (') instead of a double quote (") whenever you can. 
                        //https://plugins.jenkins.io/credentials-binding/
                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-nodes-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            //if key exists. it has permission 400 and pieline fails
                            sh 'scp $keyfile ubuntu@$ANSIBLE_SERVER:/home/ubuntu/testdir/ssh-key-new.pem'
                        }
                    }

                }
            }
        } 
    }
}