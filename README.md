# Learn Ansible!

## Branch: nexus-project-1

Prepares a remote server to run nexus.

- Needs a remote server with python3, the public ssh key and open port 22 for our IP.
- Lots of plays and lots of interesting modules. Good for practice.
- Check playbook comments for details and different techniques
- `nexus-shell.sh` is not used here. Contains steps to install nexus via shell on an Ubuntu machine

## Playbook overview

```
- name: Install nexus preqs - java and net-tools
    - name: Update repos, install java-8
    - name: Install net-tools
    - name: Install ACL to host, to resolve Becoming an Unprivileged User

- name: Download and unpack Nexus 3
    - name: Check if Nexus directory exist
    - name: Copy and unpack on serve
    - name: Find Nexus directory
    - name: Rename Nexus directory

- name: Create nexus user and permissions
    - name: Create group nexus
    - name: Create user nexus
    - name: Use file module to make nexus owner of nexus folder
    - name: Use file module to make nexus owner of sonatype-work folder

- name: Start nexus with user nexus
    - name: Set run_as_user in nexus.rc using multiline file module, blockinfile
    - name: Start nexus as nexus

- name: Verify nexus running
    - name: wait 1 minute for nexus server up and port open
    - name: Check ps
    - name: Check active servers listening with netstat
```
