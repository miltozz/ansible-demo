## Learn Ansible!

[REPO](https://gitlab.com/miltozz/learn-ansible/-/tree/jenkins-ansible-to-ec2-2)

1. Jenkins container on EC2 - Linux2
2. Ansible server on EC2 - UBUNTU
    - Can be provisioned with `ansible\prepare-ansible-server-ec2-ubu-1.sh`
3. Jenkins will run a pipeline, to connect to Ansible Server and run a playbook to configure 2 EC2 Linux2 Instances
4. EC2 Target node-instances created beforehand manually or with Terraform

More notes on Jenkinsfile

Using:
- [SSH Pipeline Steps](https://plugins.jenkins.io/ssh-steps/)
- [SSH Agent](https://plugins.jenkins.io/ssh-agent/)