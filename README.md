# Setup

## Clone code

    git clone [TODO]

## Install VirtualBox, Vagrant and Ansible
* VirtualBox: https://www.virtualbox.org/wiki/Downloads
* Vagrant: https://www.vagrantup.com/downloads.html
* Ansible: http://docs.ansible.com/intro_installation.html#latest-releases-via-apt-ubuntu

## Config
Create a .env file in the project folder and add:

    RACK_ENV=development
    PORT=5000

## Start Vagrant box

    vagrant up

## Start server

### ssh Vagrant box

    vagrant ssh
    
### Seed users

    rake db:seed

### Run mailcatcher if you want to test emails locally

    mailcatcher --http-ip=0.0.0.0

### Run server

    foreman start

Go to [http://localhost:5000](http://localhost:5000)

# Acknowledgements

Thanks to @noefroidevaux for the base Vagrant/Ansible/Ruby/Rails setup:
https://github.com/noefroidevaux/rails-workshop