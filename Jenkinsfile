pipeline {
    agent any
    environment {
        ANSIBLE_SERVER = "35.180.87.80" 
    }
 
    stages {
        stage("Copy files from Jenkins pipeline repo to ansible-server") {
            steps {
                script {
                    echo "Copy files to ansible-server"
                    // START DEPRECATED INFO - IT WORKS OK NOW
                    //Jenkins ssh agent doesn't work with new BEGIN OPENSSH PRIVATE KEY keys. it needs BEGIN RSA PRIVATE KEY.it needs PEM
                    //generate or convert keys with smth like 'ssh-keygen -m PEM -t rsa -P "" -f afile'
                    // END DEPRECATED INFO - IT WORKS OK NOW
                    sshagent(['docker-server-key']){
                        // ${ANSIBLE_SERVER}:/home/ubuntu without [user]ubuntu will give jenkins@${ANSIBLE_SERVER}:/home/ubuntu                        
                        sh "scp -o StrictHostKeyChecking=no ansible/* ubuntu@${ANSIBLE_SERVER}:/home/ubuntu/testdir"
                    

                        echo "copying ssh keys from Jenkins creds store to ansible-server for ec2 instances"
                        // note: single quotes prevent Groovy interpolation. double quoutes give unsafe warnings
                        //You should use a single quote (') instead of a double quote (") whenever you can. 
                        //https://plugins.jenkins.io/credentials-binding/
                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-nodes-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            //if key exists. it has permission 400 and pipeline fails
                            sh 'scp $keyfile ubuntu@$ANSIBLE_SERVER:/home/ubuntu/testdir/ssh-key.pem'
                        }
                    }

                }
            }
        }
        // PROBLEM: aws credentials are read from Ansible-server's ~/.aws/credentials file. below env and exports do not work. 
        // Possibly due to sinlge and double quotes and interpolation confusion
        stage("execute ansible playbook from the ansible-server") {
            environment {
                // AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                // AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                AAA='aaa'
                
            }
            steps {
                script {
                    echo "executing ansible-playbook"

                    //jenkins ssh pipeline steps uses old JSch which doesn't support newer SSH versions with keys >= 3072 bits? 
                    //New SSH versions deprecate? SHA1 and as result we have AUTH_FAIL for RSA keys of SHA1??
                    //on /var/log/auth.log I found: userauth_pubkey: key type ssh-rsa not in PubkeyAcceptedAlgorithms [preauth]
                    // temp_fix:  /etc/ssh/sshd_config--> PubkeyAuthentication yes and PubkeyAcceptedKeyTypes=+ssh-rsa
                    // then sudo service sshd reload
                    //SECURITY CONCERN?? Using deprecated formats?
                    def remote = [:]
                    remote.name = "ansible-server-ec2"
                    remote.host = ANSIBLE_SERVER
                    remote.allowAnyHosts = true
                    
                    withCredentials([sshUserPrivateKey(credentialsId: 'some-rsa-key', keyFileVariable: 'keyfile', usernameVariable: 'username')]) {
                        remote.identityFile = keyfile
                        remote.user = username
                        remote.timeoutSec = 60
                        remote.retryCount = 2
                        remote.retryWaitSec = 30
                        sshCommand remote: remote, command: 'pwd; ls -l; echo $PATH'
                        //-- sshScript remote: remote, script: 'ansible/prepare-ansible-server-ec2-ubu-1.sh'
                        sshCommand remote: remote, command: 'ansible --version'
                        sshCommand remote: remote, command:'export PATH=$PATH:/home/ubuntu/.local/bin'
                        sshCommand remote: remote, command: 'ansible --version'
                        sshCommand remote: remote, command:'ansible-inventory -i testdir/dynamic_inv_aws_ec2.yml --graph'
                                            

                        

                        //ansible-playbook command not found. sshd_config:PermitUserEnvironment: UNSAFE. Or export the path of ansible,as below 

                        // sshCommand remote: remote, command:'export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}'
                        // sshCommand remote: remote, command:'export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}'
                        //-- sshCommand remote: remote, command:'export PATH=$PATH:/home/ubuntu/.local/bin; ansible-inventory -i dynamic_inv_aws_ec2.yml --graph'
                      
                        //ALSO!!  ~/.profile adds $HOME/.local/bin to PATH. It is available after logout/login or reboot.
                        // sshCommand remote: remote, command: 'export PATH=$PATH:/home/ubuntu/.local/bin; export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}; export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}; ansible-playbook install_dock_and_compose_pb.yml'
                    }

                }
            }
        }   
    }
}