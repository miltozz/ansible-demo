## Learn Ansible!

Run from EC2 Ansible Server 3, not from local 
- has Ansible installed
- has Terraform installed
- has testkey-for-ansdok and testkey-for-ansdok.pub in ~/home/{user}/.ssh

1. Provision ec2 server with Terraform
2. Use Terraform local-exec to execute ansible-playbook from EC2 Ansible Server 3
3. Provide ansible inventory from terraform-proviioned EC2 ansdok instance(ansible-playbook parameters).
4. playbook uses `wait-for` to wait 180 seconds for open ssh port (instance to be ready for ssh connections)
5. Install Docker and docker-compose
6. Copy local docker-compose file to server
7. Start docker containers
