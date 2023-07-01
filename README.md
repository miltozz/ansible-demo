## Learn Ansible!

[REPO](https://gitlab.com/miltozz/learn-ansible/-/tree/jenkins-ansible-to-ec2-2)

1. Jenkins container on EC2 - Linux2
2. Ansible server on EC2 - UBUNTU
    - Can be provisioned with `ansible\ansible-server-prepare-ec2-ubuntu.sh`
3. Jenkins will run a pipeline, to connect to Ansible Server and run a playbook to configure  EC2 Linux2 Instances
4. EC2 Target node-instances created beforehand manually or with Terraform

5. More notes on Jenkinsfile

Using:
- [SSH Pipeline Steps](https://plugins.jenkins.io/ssh-steps/)
- [SSH Agent](https://plugins.jenkins.io/ssh-agent/)


Notes:
- Ansible VM is on the same  subnet with Remote target, so it uses private ip to SSH. In any case we should better use the SG of Ansible as an Inbound rule on target(remote) nodes.
