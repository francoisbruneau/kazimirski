# Kazimirski

[![codecov.io](https://codecov.io/github/francoisbruneau/kazimirski/coverage.svg?branch=master)](https://codecov.io/github/francoisbruneau/kazimirski?branch=master)
[![Build Status](https://travis-ci.org/francoisbruneau/kazimirski.svg?branch=master)](https://travis-ci.org/francoisbruneau/kazimirski)
[![Dependency Status](https://gemnasium.com/badges/github.com/francoisbruneau/kazimirski.svg)](https://gemnasium.com/github.com/francoisbruneau/kazimirski)
[![Code Climate](https://codeclimate.com/github/francoisbruneau/kazimirski/badges/gpa.svg)](https://codeclimate.com/github/francoisbruneau/kazimirski)

## Setup

### Clone code

    git clone git@github.com:francoisbruneau/kazimirski.git

### Install VirtualBox, Vagrant and Ansible
* VirtualBox: https://www.virtualbox.org/wiki/Downloads
* Vagrant: https://www.vagrantup.com/downloads.html
* Ansible: http://docs.ansible.com/intro_installation.html#latest-releases-via-apt-ubuntu

### Config
Create a .env file in the project folder and add:

    RACK_ENV=development
    PORT=5000

### Start Vagrant box

    vagrant up

### Start server

#### ssh Vagrant box

    vagrant ssh
    
#### Create tables and seed them with sample data

    rake db:setup

#### Run mailcatcher if you want to test emails locally

    mailcatcher --http-ip=0.0.0.0

#### Run server

    foreman start

Go to [http://localhost:5000](http://localhost:5000)

## Acknowledgements

Thanks to @noefroidevaux for the base Vagrant/Ansible/Ruby/Rails setup:
https://github.com/noefroidevaux/rails-workshop