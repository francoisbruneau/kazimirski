# Kazimirski

[![codecov.io](https://codecov.io/github/francoisbruneau/kazimirski/coverage.svg?branch=master)](https://codecov.io/github/francoisbruneau/kazimirski?branch=master)
[![Build Status](https://travis-ci.org/francoisbruneau/kazimirski.svg?branch=master)](https://travis-ci.org/francoisbruneau/kazimirski)
[![Dependency Status](https://gemnasium.com/badges/github.com/francoisbruneau/kazimirski.svg)](https://gemnasium.com/github.com/francoisbruneau/kazimirski)
[![Code Climate](https://codeclimate.com/github/francoisbruneau/kazimirski/badges/gpa.svg)](https://codeclimate.com/github/francoisbruneau/kazimirski)

The Kazimirski web application aims to facilitate crowdsourced transcription of scanned pages into digitized text, when OCRs do not produce reliable output (ex: handwritten text, old typography, or a combination of both such as in the [Kazimirski dictionary](https://archive.org/details/dictionnairearab01bibeuoft)).  

## Features

* Side-by-side transcription UI embedding [Internet Archive](https://archive.org/)'s viewer
* Custom text input logic handling specificities of bi-directional text in a dictionary
* Integration of [Trix](https://github.com/basecamp/trix) WYSIWYG editor with minimal formatting & server-side markup sanitization
* Simple checkout-submit-review workflow for contributed pages
* Straightforward role system: 
  * Transcribers can submit pages
  * Reviewers can review, correct and accept pages 
  * Admins can access the management backend
* Dashboard with overview of overall progress
* Email notifications
* Custom CAPTCHA with bi-directional text

## Setup

### Clone code

    git clone git@github.com:francoisbruneau/kazimirski.git

### Install VirtualBox, Vagrant and Ansible
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Ansible](http://docs.ansible.com/intro_installation.html#latest-releases-via-apt-ubuntu)

### Config
Create a .env file in the project folder and add:

    RACK_ENV=development
    PORT=5000
    CAPTCHA_9ad39f737b804013809c6945dbd23355=answer1
    CAPTCHA_ffa971d9f127408b88c47c734b7ddfbd=answer2
    CAPTCHA_71074c5ee3ee4b0485ef6a860f55828a=answer3

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