pipeline {
    agent any
    environment {
        // the ansible server ip
        ANSIBLE_SERVER = "13.38.56.107"

        // defined in jenkins creds. is the private key copied into ansible server, 
        // so it can connect to the target node instances that were created in ec2
        // with the corresponding public key
        TARGET_NODES_KEYNAME = "test-key-10" 
    }
 
    stages {
        stage("Copy files from Jenkins pipeline repo to ansible-server") {
            steps {
                script {
                    echo "Copy files to ansible-server"
                    // START DEPRECATED INFO - IT WORKS OK NOW
                    // Jenkins ssh agent doesn't work with new BEGIN OPENSSH PRIVATE KEY keys. it needs BEGIN RSA PRIVATE KEY.it needs PEM
                    // generate or convert keys with smth like 'ssh-keygen -m PEM -t rsa -P "" -f afile'
                    // END DEPRECATED INFO - IT WORKS OK NOW
                    sshagent(['docker-server-key']){
                        // ${ANSIBLE_SERVER}:/home/ubuntu without [user]ubuntu will give jenkins@${ANSIBLE_SERVER}:/home/ubuntu
                        // basically it defaults to [jenkins] if we don't specify user                        
                        sh "scp -o StrictHostKeyChecking=no ansible/* ubuntu@${ANSIBLE_SERVER}:/home/ubuntu"
                    
                        echo "copying ssh keys from Jenkins creds store to ansible-server for ec2 target instances"
                        // note: single quotes prevent Groovy interpolation. double quoutes give unsafe warnings
                        // You should use a single quote (') instead of a double quote (") whenever you can. 
                        // https://plugins.jenkins.io/credentials-binding/
                        withCredentials([sshUserPrivateKey(credentialsId: "${TARGET_NODES_KEYNAME}", keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            // single quotes - different syntax than above. works ok.
                            //
                            //if key exists. it has permission 400 and pipeline fails
                            sh 'if ! [[ -f "ssh-key.pem" ]]; then scp $keyfile ubuntu@$ANSIBLE_SERVER:/home/ubuntu/ssh-key.pem; fi'
                        }
                    }

                }
            }
        }
        // PROBLEM: aws credentials are read from Ansible-server's ~/.aws/credentials file.
        // below env and exports need double quotes to work with 'sshCommand remote: remote, command'
        // Double quotes produce 'insecure warnings'
        //
        // Maybe better to create the .aws/creds in the server manually (maybe some script like: wip_create_aws_creds)
        stage("execute ansible playbook from the ansible-server") {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
            }
            steps {
                script {
                    echo "executing ansible-playbook"

                    // Jenkins plugin Ssh Pipeline Steps uses old JSch which doesn't support newer SSH versions(BEGIN OPEN SSH)
                    // Generate and use RSA type of key, add private to Jenkins creds and public in Ansible Control Seerver's authorized_keys
                    //
                    // But newer SSH versions deprecate SHA1 and as result we have AUTH_FAIL for RSA keys of SHA1 ??
                    // So the RSA key is rejected with default sshd_conf
                    // On ansible server, on /var/log/auth.log: userauth_pubkey: key type ssh-rsa not in PubkeyAcceptedAlgorithms [preauth]
                    //
                    // Temp_fix:  /etc/ssh/sshd_config--> Uncomment PubkeyAuthentication yes and add PubkeyAcceptedKeyTypes=+ssh-rsa
                    // then sudo service sshd reload
                    //
                    // SECURITY CONCERN? Using deprecated formats?
                    //
                    // Jenkins creds has 'ans-server-key' as 'some-rsa-key'
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
                        //execute local script file, in the remote host
                        //sshScript remote: remote, script: 'ansible/ansible-server-prepare-ec2-ubuntu.sh'
                        
                        //ansible-playbook command not found. 
                        //----BAD SOLUTION: sshd_config:PermitUserEnvironment: UNSAFE.
                        //----GOOD SOLUTION: always export the path of ansible,as below 
                        
                        //always export any paths or env variables in each ssh command, as they don't persist between ssh sessions.
                        // e.g if using 'export PATH=$PATH:/home/ubuntu/.local/bin'
                        // or 'export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID};' (if there are no .aws/creds in the remote ansible server) 
                        // use one command, like below
                        // or pass them in every command

                        //we can skip '-i dynamic_inv_aws_ec2.yml' on ansible-playbook execution, since it is defined in ansible.cfg
                        //sshCommand remote: remote, command: "export PATH=$PATH:/home/ubuntu/.local/bin; export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}; export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}; ansible-inventory -i dynamic_inv_aws_ec2.yml --graph; ansible-playbook install_dockr_ec2-linux-sample.yml"
                        sshCommand remote: remote, command: "export PATH=$PATH:/home/ubuntu/.local/bin; export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}; export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}; ansible-inventory -i dynamic_inv_aws_ec2.yml --graph"
                        // ~/.profile adds $HOME/.local/bin to PATH. It is available after logout/login or reboot.
                        // BUT sshd_config still DOESN'T ALLOW user environment(and path) to the ssh command..
                    }

                }
            }
        }   
    }
}