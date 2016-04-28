VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # @see
  config.vm.box = "ubuntu/trusty64"

  # Unicorn
  config.vm.network "forwarded_port", guest: 5000, host: 5000

  # Postgres
  config.vm.network "forwarded_port", guest: 5432, host: 5432

  # Mailcatcher
  config.vm.network "forwarded_port", guest: 1080, host: 1080

  # TODO: Provision rdoc gem
  # RubyGems documentation server
  config.vm.network "forwarded_port", guest: 8808, host: 8808

  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/playbook_vagrant.yml"
  end
end
