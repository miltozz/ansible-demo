pipeline {
    agent any
    environment {
        ANSIBLE_SERVER = "11.111.111.11"

        
    }
 
    stages {
        stage("Copy files from Jenkins pipeline repo to ansible-server") {
            steps {
                script {
                    echo "Copy files to ansible-server"
                    //docker-paris is ans-server-key 
                    sshagent(['new-ans-server-key']){
                        sh "scp -o StrictHostKeyChecking=no ansible/* ubuntu@${ANSIBLE_SERVER}:/home/ubuntu"

                        echo "copying ssh keys from Jenkins creds store to ansible-server for ec2 instances"

                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-nodes-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            //if key exists, permission 400, pipeline fails
                            sh 'scp $keyfile ubuntu@$ANSIBLE_SERVER:/home/ubuntu/ssh-key.pem'
                        }
                    }
                }
            }
        }
        stage("execute ansible playbook from the ansible-server") {
            environment {
                // AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                // AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')                
            }
            steps {
                script {
                    echo "executing ansible-playbook"

                    // Jenkins ssh pipeline steps uses old JSch which doesn't support newer SSH key versions 
                    // New SSH versions deprecate SHA1 and as result we have AUTH_FAIL for RSA keys of SHA1(?)
                    // On /var/log/auth.log: userauth_pubkey: key type ssh-rsa not in PubkeyAcceptedAlgorithms [preauth]
                    // temp_fix:  /etc/ssh/sshd_config--> PubkeyAuthentication yes and PubkeyAcceptedKeyTypes=+ssh-rsa
                    // then sudo service sshd reload
                    // SECURITY CONCERN?
                    def remote = [:]
                    remote.name = "ansible-server-ec2"
                    remote.host = ANSIBLE_SERVER
                    remote.allowAnyHosts = true
                    
                    withCredentials([sshUserPrivateKey(credentialsId: 'new-ans-server-key', keyFileVariable: 'keyfile', usernameVariable: 'username')]) {
                        remote.identityFile = keyfile
                        remote.user = username
                        remote.timeoutSec = 60
                        remote.retryCount = 2
                        remote.retryWaitSec = 30
                        sshCommand remote: remote, command: 'pwd; ls -l; echo $PATH'
                        sshScript remote: remote, script: 'ansible/prepare-ansible-server-ec2-ubu-1.sh'
                                            

                        

                        //ansible-playbook command not found. sshd_config:PermitUserEnvironment: UNSAFE. Or export the path of ansible,as below 

                        // sshCommand remote: remote, command:'export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}'
                        // sshCommand remote: remote, command:'export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}'
                        sshCommand remote: remote, command:'export PATH=$PATH:/home/ubuntu/.local/bin; ansible-inventory -i dynamic_inv_aws_ec2.yml --graph'
                      
                        //ALSO!!  ~/.profile adds $HOME/.local/bin to PATH. It is available after logout/login or reboot.
                        // sshCommand remote: remote, command: 'export PATH=$PATH:/home/ubuntu/.local/bin; export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}; export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}; ansible-playbook install_dock_and_compose_pb.yml'
                    }

                }
            }
        }   
    }
}