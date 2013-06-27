# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.berkshelf.enabled = true

  # Shared provisioning between dev and prod
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "build-essential"
    chef.add_recipe "ohai"
    chef.add_recipe "apt"
    chef.add_recipe "memcached"
    chef.add_recipe "nginx"
    chef.add_recipe "mysql::server"
    chef.add_recipe "redisio::install"
    chef.add_recipe "redisio::enable"
    chef.add_recipe "database"
    chef.add_recipe "imagemagick"
    chef.add_recipe "sudo"

    chef.json = { 
      # CUSTOM SNGTRKR CONFIGURATION PARAMETERS
      'sngtrkr' => {
        'shims_path' => "/home/vagrant/.rbenv/bin/rbenv exec ",
        'app_path' => "/home/vagrant/sngtrkr_rails_prod",
      },
      'ruby_stack' => {
        "rubies" => ['2.0.0-p195'],
        "global" => '2.0.0-p195',
        "users" =>  ["vagrant"],
        "vendor_gems" => true
      },
      'mysql' => {
        "server_root_password" => ENV['SNGTRKR_DB_PW'],
        "server_repl_password" => ENV['SNGTRKR_DB_PW'],
        "server_debian_password" => ENV['SNGTRKR_DB_PW'],
        "tunable" => {
          "key_buffer_size" => "16M",
          "innodb_buffer_pool_size" => "64M",
          "innodb_additional_mem_pool_size" => "2M"
        }
      },
      'authorization' => {
        'sudo' => {
          'include_sudoers_d' => true 
          } 
        }
    }

    chef.data_bags_path = "data_bags"

  end    

  config.vm.define :dev do |dev|
    dev.vm.box = "raring"
    dev.vm.box_url = "http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box"
    dev.vm.network :forwarded_port, guest: 80, host: 8000
    dev.vm.network :forwarded_port, guest: 3000, host: 3000
    dev.vm.network :forwarded_port, guest: 8080, host: 8080

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    dev.vm.network :private_network, ip: "192.168.33.10"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # dev.vm.network :public_network

    dev.vm.synced_folder ".", "/home/vagrant/sngtrkr_rails_dev", :nfs => true

    dev.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1500"]
    end

    dev.vm.provision :chef_solo do |chef|
      chef.add_recipe "sngtrkr::development"
    end
  end

  config.vm.define :prod do |prod|
    prod.vm.synced_folder '.', '/vagrant', :disabled => true
    prod.vm.synced_folder 'data_bags', '/var/chef/data_bags'
    prod.omnibus.chef_version = :latest
    prod.ssh.private_key_path = '~/.ssh/digital_ocean_sngtrkr'
    prod.ssh.username = 'root'
    prod.vm.box = 'digital_ocean'

    prod.vm.provider :digital_ocean do |provider|
      provider.client_id = 'XgUtUYzRWL2RuG1E7c8NW'
      provider.api_key = 'MYVXxvCiDVvzHcA2puxbihzhWwwOoXUWSMdsrOsXg'
      provider.image = "Ubuntu 13.04 x64"
      provider.region = "Amsterdam 1"
      provider.size = "1GB"
      provider.ssh_key_name = "sngtrkr_vagrant"
    end

    prod.vm.provision :chef_solo do |chef|
      chef.add_recipe "sngtrkr::production"
    end

  end

end
