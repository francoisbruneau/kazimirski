# Setup

# Clone code

    git clone git@github.com:noefroidevaux/rails-workshop.git

# Install VirtualBox, Vagrant and Ansible
* VirtualBox: https://www.virtualbox.org/wiki/Downloads
* Vagrant: https://www.vagrantup.com/downloads.html
* Ansible: http://docs.ansible.com/intro_installation.html#latest-releases-via-apt-ubuntu

# Config
Create a .env file in the project folder and add:

    RACK_ENV=development
    PORT=5000

# Start Vagrant box
vagrant up

# Start server

## ssh Vagrant box

    vagrant ssh

## Run server

    foreman start

Go to [http://localhost:5000](http://localhost:5000)
