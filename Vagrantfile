# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  config.vm.define "linux-x86_64", primary: true do |box|
    box.vm.box = "ubuntu/trusty64"
  end

  config.vm.define "linux-x86" do |box|
    box.vm.box = "ubuntu/trusty32"
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 4567, host: 4567

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end


  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # sudo apt-get update
  # sudo apt-get install -y apache2
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update

    sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

    sudo apt-get install -y libavahi-compat-libdnssd-dev
    sudo apt-get install -y nodejs
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL

    if [ ! -d "$HOME/.rbenv" ]; then
      echo "Installing rbenv and ruby-build"

      git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
      git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

      echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
      echo 'eval "$(rbenv init -)"' >> ~/.bashrc

      echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc_ssh
      echo 'eval "$(rbenv init -)"' >> ~/.bashrc_ssh

    else
      echo "Updating rbenv and ruby-build"

      cd ~/.rbenv
      git pull

      cd ~/.rbenv/plugins/ruby-build
      git pull
    fi

    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"

    if [ ! -d "$HOME/.rbenv/versions/2.1.6" ]; then
      echo "Installing ruby"

      rbenv install 2.1.6
      rbenv global 2.1.6

      gem update --system
      gem update

      gem install bundler

      rbenv rehash
    fi
  SHELL

end
