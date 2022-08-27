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

                    sshagent(['ansible-server-key']){
                        // ${ANSIBLE_SERVER}:/home/ubuntu without [user]ubuntu will give jenkins@${ANSIBLE_SERVER}:/home/ubuntu                        
                        sh "scp -o StrictHostKeyChecking=no ansible/* ubuntu@${ANSIBLE_SERVER}:/home/ubuntu"
                    

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
        stage("execute ansible playbook from the ansible-server") {
            // environment {
            //     AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
            //     AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
            // }
            steps {
                script {
                    echo "executing ansible-playbook"
                    
                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = ANSIBLE_SERVER
                    remote.allowAnyHosts = true
                    
                    withCredentials([sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                        remote.identityFile = keyfile
                        remote.user = user

                        sshCommand remote: remote, command: "pwd"
                        
                        // set AWS credentials
                        //sshScript remote: remote, script: "ansible/prepare-server.sh"
                        
                        //sshCommand remote: remote, command: "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}; export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}; ansible-playbook docker-and-compose.yaml"
                    }
                }
            }
        }   
    }
}
