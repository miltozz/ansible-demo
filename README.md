# Learn Ansible!

## Branch: node-project-1

Deploy a simple node app from local workstation to an ec2 ubuntu server

- EC2 must be created with public ssh key and open port 22 for ssh from our IP(or ansible server's key and IP).
- Simple node app on local host in .tgz
- Playbook vars_files
    - node_artifact_location: [_path-to-dir-containing-the-tgz_]
    - app_version: [_1.0.0_]
    - user_name: [_username for created user_]
    - user_home_location: [_home path of created user_]
- Playbook plays
    - Update apt and install node, npm, acl
    - Create new linux user with admin rights
    - Deploy nodejs sample app
- See playbook comments for details
- Useful terraform to spin up an EC2 ubuntu [here](https://github.com/thelongestyard/terraform-demo/blob/deploy-1-ec2-ubuntu/README.md)
